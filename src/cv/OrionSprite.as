package cv {
	
	import cv.orion.Orion;
	import cv.orion.events.ParticleEvent;
	import cv.orion.interfaces.IFilter;
	import cv.orion.ParticleVO;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class OrionSprite extends Orion {
		
		protected static const RESET_MATRIX:Matrix = new Matrix();
		
		protected static const RESET_COLORTRANSFORM:ColorTransform = new ColorTransform();
		
		/**
		 * Gets or sets the blend mode applied to particles when they are created. It is also
		 * used when caching particles.
		 */
		public var cacheBlendMode:String = BlendMode.NORMAL;
		
		/**
		 * Gets or sets pixel snapping when frame caching is enabled. Pixel snapping
		 * determines whether or not the Bitmap object is snapped to the nearest pixel.
		 */
		public var cachePixelSnapping:String = PixelSnapping.NEVER;
		
		/**
		 * Gets or sets bitmap smoothing when using frame caching.
		 */
		public var cacheSmoothing:Boolean = false;
		
		/**
		 * Gets or sets whether bitmap caching is enabled on particles used within this emitter. 
		 * If set to true, Flash Player or Adobe AIR caches an internal bitmap representation of 
		 * the display object. This caching can increase performance for display objects that 
		 * contain complex vector content.
		 */
		public var useCacheAsBitmap:Boolean = false;
		
		/** @private */
		protected var _cacheFrames:Vector.<BitmapData>;
		/** @private */
		protected var _cacheTarget:DisplayObject;
		/** @private */
		protected var _spriteClass:Class;
		/** @private */
		protected var _useFrameCaching:Boolean = false;
		/** @private */
		protected const _clr:ColorTransform = new ColorTransform();
		
		public function OrionSprite(spriteClass:Class, config:Object = null) {
			_spriteClass = spriteClass;
			_particles = createParticle();
			super(config);
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * The storage location for frames that are cached. Used by filters and emitters.
		 */
		public function get cacheFrames():Vector.<BitmapData> { return _cacheFrames; }
		
		/**
		 * Gets the frame cache movieclip. This is the movieclip that has had
		 * it's frames cached.
		 */
		public function get cacheTarget():DisplayObject { return _cacheTarget; }
		
		/**
         * Gets or sets the specific library linkId (class reference)
		 */
		public function get spriteClass():Class { return _spriteClass; }
		/** @private **/
		public function set spriteClass(value:Class):void {
			_spriteClass = value;
			removeAllParticles();
			_cacheTarget = null;
			_cacheFrames = null;
		}
		
		/**
		 * Gets or sets whether frame caching will be enabled. Frame caching takes a snapshot
		 * of each frame of a movieclip and stores the bitmaps in an vector. This bitmapdata is
		 * used later for new particles. This can greatly improve performance on occasion (especially
		 * movieclips with lots of fiters used inside or multiple frames).
		 */
		public function get useFrameCaching():Boolean { return _useFrameCaching; }
		/** @private **/
		public function set useFrameCaching(value:Boolean):void {
			_useFrameCaching = value;
			removeAllParticles();
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		override public function applyPreset(config:Object = null, reset:Boolean = false):void {
			super.applyPreset(config, reset);
			
			if (config) {
				if (config.hasOwnProperty("useFrameCaching") && config.useFrameCaching is Boolean) this.useFrameCaching = config.useFrameCaching;
				if (config.hasOwnProperty("cacheBlendMode") && config.cacheBlendMode is String) this.cacheBlendMode = config.cacheBlendMode;
				if (config.hasOwnProperty("cachePixelSnapping") && config.cachePixelSnapping is String) this.cachePixelSnapping = config.cachePixelSnapping;
				if (config.hasOwnProperty("cacheSmoothing") && config.cacheSmoothing is Boolean) this.cacheSmoothing = config.cacheSmoothing;
			}
		}
		
		/**
		 * Updates all the particles and positions, updates the output class as well.
		 * 
		 * @param	e The event dispatched.
		 * @default null
		 */
		override public function render(e:Event = null):void {
			// Draw boxes for emitter and canvas
			if (debug) {
				this.graphics.clear();
				this.graphics.lineStyle(1, 0x00FF00, 1, true);
				this.graphics.drawRect(this.x, this.y, this.width, this.height);
				this.graphics.moveTo(this.x, this.y);
				this.graphics.lineTo(this.x, this.y);
				this.graphics.lineTo(this.x + this.width, this.y + this.height);
				this.graphics.moveTo(this.x + this.width, this.y);
				this.graphics.lineTo(this.x + this.width, this.y);
				this.graphics.lineTo(this.x, this.y + this.height);
				if(canvas) {
					this.graphics.lineStyle(1, 0xFF0000, 1, true);
					this.graphics.drawRect(canvas.x, canvas.y, canvas.width, canvas.height);
				}
			}
			
			if (paused) return;
			
			var lifeSpan:uint = settings.lifeSpan;
			var particle:ParticleVO = _particles;
			var numAdd:uint = output.getOutput(this);
			var numEmit:int = _emitQueue.length - 1;
			var length:uint = 0;
			var curTime:uint = Orion.time;
			var i:uint;
			var effectFiltersLength:uint = effectFilters.length;
			var _effectFilters:Vector.<IFilter> = effectFilters;
			var _edgeFilter:IFilter = edgeFilter;
			var dispatch:Boolean = (_willTriggerFlags & 0x08) != 0;
			var event:ParticleEvent = _eventUpdate;
			var j:uint;
			var c:Point;
			
			do {
				if(particle.active) {
					// Too old
					if (lifeSpan > 0) {
						if ((curTime - particle.timeStamp) > lifeSpan) {
							removeParticle(particle);
							continue;
						}
					}
					
					// Count particles
					++length;
					
					if (!particle.paused) {
						// Apply Filters
						i = effectFiltersLength;
						if(i > 0) {
							while (--i > -1) {
								_effectFilters[i].applyFilter(particle, this);
							}
						}
						
						// Position particle
						if (particle.velocityX != 0) particle.target.x += particle.velocityX;
						if (particle.velocityY != 0) particle.target.y += particle.velocityY;
						if (particle.velocityZ != 0) particle.target.rotation += particle.velocityZ;
						if (_edgeFilter) _edgeFilter.applyFilter(particle, this);
					}
					
					// Dispatch update event
					if (dispatch) {
						event.particle = particle;
						dispatchEvent(event);
					}
				} else if (numAdd > 0) {
					// Add new
					if(addParticle(particle)) --numAdd;
				} else if (numEmit >= 0) {
					// Emit new
					addParticle(particle, _emitQueue[numEmit].coord);
					
					// Reduce the amount and let the loop create more particles as necessary
					--_emitQueue[numEmit].amount;
					if (_emitQueue[numEmit].amount <= 0) {
						_emitQueue.pop();
						--numEmit;
					}
				}
				
				// If more particles need to be emitted and the list is at the end, add more particles
				if (particle.next == null && (numAdd || numEmit > -1)) {
					particle = particle.next = createParticle();
				} else {
					particle = particle.next;
				}
			} while (particle);	
			
			_numParticles = length;
			
			if ((_willTriggerFlags & 0x02) != 0)  dispatchEvent(_eventChange);
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		override protected function additionalInit(p:ParticleVO, pt:Point):void {
			if(settings.velocityRotateMin != settings.velocityRotateMax) {
				p.velocityZ = randomRange(settings.velocityRotateMin, settings.velocityRotateMax);
			} else {
				p.velocityZ = settings.velocityRotate;
			}
			
			if(settings.colorMin != settings.colorMax) {
				_clr.color = interpolateColor(settings.colorMin, settings.colorMax, Math.random());
			} else if(!isNaN(settings.color)) {
				_clr.color = settings.color;
			}
			
			if(settings.alphaMin != settings.alphaMax) {
				_clr.alphaMultiplier = randomRange(settings.alphaMin, settings.alphaMax);
			} else {
				_clr.alphaMultiplier = settings.alpha;
			}
			
			var scale:Number = settings.scale;
			if (settings.scaleMin != settings.scaleMax) {
				scale = randomRange(settings.scaleMin, settings.scaleMax);
			}
			
			var rotate:Number = settings.rotate;
			if(settings.rotateMin != settings.rotateMax) {
				rotate = randomRange(settings.rotateMin, settings.rotateMax);
			}
			
			// Goto a random frame or the first frame
			var frame:int = 1;
			var frameLength:int = useFrameCaching ? _cacheFrames.length - 1 : 1;
			if (p.isMovieClip) frameLength = MovieClip(p.target).totalFrames;
			if (settings.selectRandomFrame) frame = int(randomRange(0, frameLength));
			if (p.currentFrame != frame) {
				if (useFrameCaching) {
					Bitmap(p.target).bitmapData = _cacheFrames[frame - 1];
				} else if(p.isMovieClip) {
					MovieClip(p.target).gotoAndStop(frame);
				}
			}
			p.currentFrame = frame;
			
			// Update position/color
			_mtx.identity();
			_mtx.createBox(scale, scale, rotate * DEG2RAD, pt.x, pt.y);
			p.target.transform.colorTransform = _clr;
			p.target.transform.matrix = _mtx;
			
			this.addChild(p.target);
		}
		
		/**
		 * If it's a movieclip, cache it's frames.
		 * 
		 * @param	mc The particle to have it's frames cached.
		 */
		//http://www.bytearray.org/?p=751
		//http://theflashblog.com/?p=259
		protected function cacheFramesOf(mc:DisplayObject):void {
			var bounds:Rectangle, bmpData:BitmapData, matrix:Matrix, isMovieClip:Boolean = (mc is MovieClip), i:uint = (isMovieClip) ? MovieClip(mc).totalFrames : 1;
			_cacheTarget = mc;
			_cacheFrames = new Vector.<BitmapData>(i, true);
			
			//var x:Number = 0;
			while (i--) {
				// << 1 is the same as * 2
				bounds = _cacheTarget.getBounds(_cacheTarget);
				matrix = RESET_MATRIX;
				matrix.translate(bounds.left, bounds.top);
				matrix.invert();
				bmpData = new BitmapData(_cacheTarget.width, _cacheTarget.height, true, 0);
				bmpData.draw(_cacheTarget, matrix, RESET_COLORTRANSFORM, cacheBlendMode, null, cacheSmoothing);
				_cacheFrames[i] = bmpData;
				if(isMovieClip) MovieClip(_cacheTarget).nextFrame();
				
				// Debugging
				/*var spr:Sprite = new Sprite();
				var bmp:Bitmap = new Bitmap(bmpData);
				spr.addChild(bmp);
				bmp.x = bounds.left * 2;
				bmp.y = bounds.top * 2;
				spr.x = x;
				x += spr.width;
				this.stage.addChild(spr);*/
			}
			
			if(isMovieClip) MovieClip(_cacheTarget).gotoAndStop(1);
		}
		
		/**
		 * Checks the recycle bin if a suitable particle can be re-used.
		 * 
		 * @return	The particle
		 */
		override protected function createParticle(idx:int = 0):ParticleVO {
			// Create new particle
			var d:DisplayObject;
			if (useFrameCaching) {
				if (_cacheFrames && _cacheFrames.length != 0) {
					// Init particle with reference of movieclip
					d = getCached();
				} else {
					d = new _spriteClass();
					cacheFramesOf(d);
					d = getCached();
				}
			} else {
				d = new _spriteClass();
				d.blendMode = cacheBlendMode;
				d.cacheAsBitmap = useCacheAsBitmap;
			}
			
			return new ParticleVO(d);
		}
		
		protected function getCached():Bitmap {
			var bmp:Bitmap = new Bitmap(_cacheFrames[0], cachePixelSnapping, cacheSmoothing);
			bmp.blendMode = cacheBlendMode;
			bmp.cacheAsBitmap = useCacheAsBitmap;
			return bmp;
		}
		
		/**
		 * Removes a particle and stores the reference to the particle inside 
		 * of the recyclebin dictionary.
		 */
		override protected function removeParticle(p:ParticleVO):void {
			if(p.target.parent) this.removeChild(p.target);
			super.removeParticle(p);
		}
	}
}