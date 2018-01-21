/**
* Orion ©2009 Gabriel Mariani. February 9th, 2009
* Visit http://blog.coursevector.com/orion for documentation, updates and more free code.
*
*
* Copyright (c) 2009 Gabriel Mariani
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

// TweenLite helped too
// BetweenAS3 helped too
// http://blog.joa-ebert.com/2009/04/03/massive-amounts-of-3d-particles-without-alchemy-and-pixelbender/

package cv {
	
	import cv.orion.CacheFrameVO;
	import cv.orion.interfaces.IFilter;
	import cv.orion.interfaces.IOutput;
	import cv.orion.ParticleVO;
	import cv.orion.RenderEvent;
	import cv.orion.SettingsVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	//import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	//--------------------------------------
    //  Events
    //--------------------------------------
    
	/**
	* This event is dispatched each time Orion renders the particles.
	*
	* @eventType flash.events.Event
	**/
	[Event(name="change", type="flash.events.Event")]
	
	/**
	* This event is dispatched each time Orion is resized.
	*
	* @eventType flash.events.Event
	**/
	[Event(name="resize", type="flash.events.Event")]
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * <strong>Orion ©2009 Gabriel Mariani, coursevector.com.
	 * <br/>Visit http://blog.coursevector.com/orion for documentation, updates and more 
	 * free code.
	 * <br/>Licensed under the MIT license - see the source file header 
	 * for more information.</strong>
	 * <hr>
	 * Orion is an easy to use and light-weight particle system. It's instance 
	 * oriented much like GTween so you can re-use and modify easily. It's 
	 * also very fast, capable of handling over 3000 particles at more than 
	 * 30fps if your computer can handle it. But unless you're doing something 
	 * really intense you probably won't notice any slowdown. At it's smallest
	 * Orion will add about 6kb to your filesize.
	 * <br/><br/>
	 * The Orion class is the hub of particle system. It  
	 * determines <strong>where</strong> the particles will be generated.
	 * All particles are generated within the bounds of the Orion instance.
	 * So if you set it up to be 100x100, the particles will be generated 
	 * somewhere within that area. If you set the width and height below
	 * 1 (i.e. 0x0), it will generate all the particles at the center of the 
	 * instance.
	 * <br/><br/>
	 * To control where the particles can be displayed you can modify the 
	 * canvas property. The canvas is a simple rectange object, changing the
	 * height, width, and position of it will determine where the particles 
	 * will be displayed and when the edgeFilter will take action.
	 * <br/><br/>
	 * Orion is easy to use and incredibly flexible and customizable. To keep 
	 * it's size down, there are effectFilters, the more you add the more work 
	 * Orion has to do which can affect performance and filesize. So keep this 
	 * in mind before you use every filter and wonder why it's not handling 
	 * 3000 particles easily. Below are some examples to show you how to use 
	 * Orion and how quickly you can get up and running. Since Orion is so 
	 * customizable, I thought it would be nice to be able to save those 
	 * configurations so you can use the same settings again. This is what the 
	 * presets are used for. They will configure an instance of Orion with the 
	 * given settings. If you have to find a setting you like you can create 
	 * your own presets and load them as well.
	 * 
	 * @example The only requirement to use Orion is to have an item exported from the library.
	 * <br/><br/>
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.preset.Default; // A small set of common presets
	 * 
	 * var e:Orion = new Orion(linkageClass, null, Default.firework());
	 * this.addChild(e);
	 * 
	 * </listing>
	 * <br/><br/>
	 * That's it! Although that is a very basic setup but as you can see, it doesn't take much work to get a particle
	 * system up and running in your code.
     */
	public class Orion extends Sprite implements IOutput {
		
		/**
		 * Stored decimal value for conversion
		 */
		public static const DEG2RAD:Number = 0.01745329;// Math.PI / 180
		public static const PI_D2:Number = 1.57079632;// Math.PI / 2
		public static const PI_M2:Number = 6.28318531;// Math.PI * 2
		public static const PI:Number = 3.14159265;// Math.PI
		public static const PI_42:Number = 0.405284735;// -4 / (Math.PI ^ 2)
		public static const PI_4:Number = 1.27323954;// 4 / Math.PI
		public static const denormal:Number = 1e-18;
		/**
		 * var n:int=0xfffff;

	while ( --n > -1 ) {
		//_denormals[n]*=0.5;
		_denormals[ n ] = _denormals[ n ] * 0.5 + denormal - denormal;//avoiding denormals
	}//do some calculations with veery small numbers
		 */
		
		public static const RESET_MATRIX:Matrix = new Matrix();
		public static const RESET_COLORTRANSFORM:ColorTransform = new ColorTransform();
		
		/**
		 * The current version of Orion.
		 */
		public static const VERSION:String = "1.1.0";
		
		/**
		 * Current Time
		 */
		public static var time:uint;
		
		/**
		 * Gets or sets the blend mode applied to particles when they are created. It is also
		 * used when caching particles.
		 */
		public var cacheBlendMode:String = BlendMode.NORMAL;
		
		/**
		 * Gets or sets pixel snapping when frame caching is enabled. Pixel snapping
		 * determines whether or not the Bitmap object is snapped to the nearest pixel.
		 */
		public var cachePixelSnapping:String = PixelSnapping.AUTO;
		
		/**
		 * Gets or sets bitmap smoothing when using frame caching.
		 */
		public var cacheSmoothing:Boolean = false;
		
		/**
		 * The canvas is used to control the boundaries (edge filter) of the particles animating.
		 */
		public var canvas:Rectangle;
		
		/**
		 * Triggers the emitters everytime a particle from this emitter
		 * is created. This allows for effects like the explosion before a firework goes up.
		 * 
		 * This vector can only accept instances of the Orion class.
		 * 
		 * When using this, specify the output of the child emitter to the parent emitter.
		 */
		public var createEmitters:Vector.<Orion> = new Vector.<Orion>();
		
		/**
		 * Turns on debug lines to outline the emitter and canvas dimensions
		 */
		public var debug:Boolean = false;
		
		/**
		 * Triggers the emitters everytime a particle from this emitter
		 * is destroyed. This allows for effects like the explosion after a firework goes up.
		 * 
		 * This vector can only accept instances of the Orion class.
		 * 
		 * When using this, specify the output of the child emitter to the parent emitter.
		 */
		public var destroyEmitters:Vector.<Orion> = new Vector.<Orion>();
		
		/**
		 * Gets or sets the edge filter used by the emitter to determine what the particles
		 * will do when they hit the edge. Pass nothing to it in order to reset it.
		 */
		public var edgeFilter:IFilter;
		
		/**
		 * Gets the filters being applied by the emitter.
		 */
		public var effectFilters:Vector.<IFilter> = new Vector.<IFilter>();
		
		/**
         * Gets or sets the output class used. The default is the <code>null</code>.
		 */
		public var output:IOutput;
		
		/**
		 * The settings object controls all configuration. The settings object can contain the following properties :
		 */
		public var settings:SettingsVO = new SettingsVO();
		
		/**
		 * Triggers the emitters everytime a particle from this emitter
		 * gets updated. This allows for effects like trailing smoke of a particle.
		 * 
		 * This vector can only accept instances of the Orion class.
		 * 
		 * When using this, specify the output of the child emitter to the parent emitter.
		 */
		public var updateEmitters:Vector.<Orion> = new Vector.<Orion>();
		
		/**
		 * Gets or sets whether bitmap caching is enabled on particles used within this emitter. 
		 * If set to true, Flash Player or Adobe AIR caches an internal bitmap representation of 
		 * the display object. This caching can increase performance for display objects that 
		 * contain complex vector content.
		 */
		public var useCacheAsBitmap:Boolean = false;
		
		/** @private */
		protected var _cacheFrames:Vector.<CacheFrameVO>;
		/** @private */
		protected var _cacheTarget:DisplayObject;
		/** @private */
		protected const _mtx:Matrix = new Matrix();
		/** @private */
		protected const _clr:ColorTransform = new ColorTransform();
		/** @private */
		protected const _pt:Point = new Point();
		/** @private */
		protected const _emitter:Rectangle = new Rectangle();
		/** @private */
		protected static const _eventChange:Event = new Event(Event.CHANGE);
		/** @private */
		protected static const _eventResize:Event = new Event(Event.RESIZE);
		/** @private */
		protected static const _eventTick:Event = new Event("tick");
		/** @private */
		protected var _particles:Vector.<ParticleVO> = new Vector.<ParticleVO>();
		/** @private */
		protected var _cursor:uint = 0;
		/** @private */
		protected var _recycleBin:Vector.<ParticleVO> = new Vector.<ParticleVO>();
		/** @private */
		protected var _recycleBinlength:uint = 0;
		/** @private */
		protected var _particle:ParticleVO;
		protected var _particlesTest:ParticleVO;
		/** @private */
		protected var _paused:Boolean = false;
		/** @private */
		protected static const _shape:Shape = new Shape(); //A reference to the sprite that we use to drive all our ENTER_FRAME events.
		/** @private */
		protected var _spriteClass:Class;
		/** @private */
		protected var _useFrameCaching:Boolean = false;
		/** @private */
		protected var _willTriggerFlags:uint = 0;
		protected var maxParticles:uint = 30000;
		protected var numParticles:uint = 0;
		
		/**
		 * The constructor allows a few common settings to be specified during construction. Options such
		 * as the output class or any configuration settings.
		 * 
		 * @param	spriteClass This is the linkage class of the item you have exported from the library.
		 * @param	output	Here you can specify which output class you'd like to use. If you don't want to 
		 * use one, just leave this as <code>null</code>
		 * @param	config	Here you can pass in a <code>configuration</code> object. A <code>configuration</code> object is generated by a 
		 * preset or you can write one by hand. Each <code>configuration</code> object can contain an <code>effectFilters</code> vector, an
		 * <code>edgeFilter</code> object, and a <code>settings</code> object. The <code>settings</code> object can contain all the same properties that
		 * modifying the <code>settings</code> property directly allows.
		 * @param	useFrameCaching	Frame caching is useful for particles that have a lot of glow filters or native Flash filters applied.
		 * Turning on frame caching will cause Orion to take a snapshot of each frame of the particle and turn it into a Bitmap and use the Bitmap
		 * instead. This can greatly increase performance for complicated particles.
		 * 
		 * @see Orion#settings
		 * @see Orion#useFrameCaching
		 */
		public function Orion(spriteClass:Class = null, output:IOutput = null, config:Object = null, useFrameCaching:Boolean = false) {
			_spriteClass = spriteClass;
			
			// Init Settings
			this.useFrameCaching = useFrameCaching;
			this.output = output || this;
			applyPreset(config);
			
			createAllParticles();
			
			// Init static settings
			if(!_shape.hasEventListener(Event.ENTER_FRAME)) _shape.addEventListener(Event.ENTER_FRAME, tick, false, 0, true);
			_shape.addEventListener("tick", render, false, 0, true);
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * The storage location for frames that are cached. Used by filters and emitters.
		 */
		public function get cacheFrames():Vector.<CacheFrameVO> { return _cacheFrames; }
		
		/**
		 * Gets the frame cache movieclip. This is the movieclip that has had
		 * it's frames cached.
		 */
		public function get cacheTarget():DisplayObject { return _cacheTarget; }
		
		/**
		 * Gets or sets the height of the emitter.
		 */
		override public function get height():Number { return _emitter.height; }
		/** @private **/
		override public function set height(value:Number):void {
			_emitter.height = value;
			if ((_willTriggerFlags & 0x01) != 0) dispatchEvent(_eventResize);
		}
		
		/**
		 * The vector of all the particles in this instance of Orion
		 */
		public function get particles():Vector.<ParticleVO> { return _particles; }
		
		public function get particlesLength():uint { return _cursor; }
		
		/**
		 * Gets or sets the paused property
		 */
		public function get paused():Boolean { return _paused; }
		/** @private **/
		public function set paused(value:Boolean):void {
			if (value == _paused) return;
			_paused = value;
			if (value) {
				_shape.removeEventListener("tick", render);
				// Render one more time after being paused
				render();
			} else {
				_shape.addEventListener("tick", render, false, 0, true);
			}
		}
		
		/**
         * Gets or sets the specific library linkId (class reference)
		 */
		public function get spriteClass():Class { return _spriteClass; }
		/** @private **/
		public function set spriteClass(value:Class):void {
			_spriteClass = value;
			removeAllParticles();
			killGarbage();
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
			killGarbage();
		}
		
		/**
		 * Gets or sets the width of the emitter.
		 */
		override public function get width():Number { return _emitter.width; }
		/** @private **/
		override public function set width(value:Number):void {
			_emitter.width = value;
			if ((_willTriggerFlags & 0x01) != 0) dispatchEvent(_eventResize);
		}
		
		/**
		 * Gets or sets the x position of the emitter.
		 * 
		 * @see Orion#getCoordinate()
		 * @see Orion#y
		 */
		override public function get x():Number { return _emitter.x; }
		/** @private **/
		override public function set x(value:Number):void {	_emitter.x = value; }
		
		/**
		 * Gets or sets the y position of the emitter.
		 * 
		 * @see Orion#getCoordinate()
		 * @see Orion#x
		 */
		override public function get y():Number { return _emitter.y; }
		/** @private **/
		override public function set y(value:Number):void { _emitter.y = value;	}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		public function createAllParticles():void {
			if(1 > maxParticles) return;
			
			_particlesTest = createParticle();
			
			var currentParticle:ParticleVO = _particlesTest;
			var i:int = maxParticles;
			while (--i != 0) {
				currentParticle = currentParticle.next = createParticle();
			}
		}
		
		private function createParticle():ParticleVO {
			// Create new particle
			var d:Object;
			if (useFrameCaching) {
				if (_cacheFrames && _cacheFrames.length != 0) {
					// Init particle with reference of movieclip
					d = getCached();
				} else {
					d = getNew();
					if (d is DisplayObject) {
						cacheFramesOf(d as DisplayObject);
						d = getCached();
					} else {
						useFrameCaching = false;
						trace("Orion error! Cannot cache frames of designated SpriteClass. SpriteClass must be a Movieclip to cache frames : [" + _spriteClass + "]");
					}
				}
			} else {
				d = getNew();
				if(d is DisplayObject) {
					d.blendMode = cacheBlendMode;
					d.cacheAsBitmap = useCacheAsBitmap;
				}
			}
			
			return new ParticleVO(d);
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			updateWillTriggerFlags();
		}
		
		public function applyPreset(config:Object = null, reset:Boolean = false):void {
			if (reset) {
				this.edgeFilter = null;
				this.effectFilters = new Vector.<IFilter>();
				this.settings = new SettingsVO();
			}
			
			if(config) {
				if (config.hasOwnProperty("effectFilters") && config.effectFilters is Vector.<IFilter>) this.effectFilters = config.effectFilters;
				if (config.hasOwnProperty("settings") && config.settings is SettingsVO) this.settings = config.settings;
				if (config.hasOwnProperty("edgeFilter")) this.edgeFilter = config.edgeFilter;
				if (config.hasOwnProperty("maxParticles") && !isNaN(config.maxParticles)) this.maxParticles = uint(config.maxParticles);
			}
		}
		
		/**
		 * Causes the emitter to add particles.
		 * 
		 * @param	point	Where to position the particle
		 * @param	numberOfParticles How many particles are emitted during each emit&#40;&#41; call.
		 */
		public function emit(point:Point = null):void {
			if (paused) return;
			//var i:uint = settings.numberOfParticles;
			//while (i--) addParticle(null, point);
		}
		
		/**
		 * Finds a color that's between the two numbers given.
		 * 
		 * @internal Utility function
		 * 
		 * @param	fromColor<uint> The first color
		 * @param	toColor<uint> The second color
		 * @param	progress<Number> The ratio between the two colors you want returned.
		 * @return The color between the two colors.
		 */
		public static function interpolateColor(fromColor:uint, toColor:uint, progress:Number):uint {
			var n:Number = 1 - progress; // Alpha
			var red:uint = uint(((fromColor >>> 16) & 255) * progress + ((toColor >>> 16) & 255) * n);
			var green:uint = uint(((fromColor >>> 8) & 255) * progress + ((toColor >>> 8) & 255) * n);
			var blue:uint = uint(((fromColor) & 255) * progress + ((toColor) & 255) * n);
			var alpha:uint = uint(((fromColor >>> 24) & 255) * progress + ((toColor >>> 24) & 255) * n);
			return (alpha << 24) | (red << 16) | (green << 8) | blue;
		}
		
		/**
		 * This will run ever 2 seconds and remove any inactive particles from memory.
		 * 
		 * @param	e The event dispatched.
		 * @default null
		 */
		public function killGarbage():void {
			_recycleBinlength = 0;
			_recycleBin = new Vector.<ParticleVO>();
		}
		
		/**
		 * Pauses the particle system
		 */
		public function pause():void {
			this.paused = true;
		}
		
		/**
		 * Resumes or plays the particle system
		 */
		public function play():void {
			this.paused = false;
		}
		
		/**
		 * Removes all particles from the emitter.
		 * This also frees up any memory used by the particles.
		 */
		public function removeAllParticles():void {
			var particle:ParticleVO = _particlesTest;
			if(particle) {
				do {
					removeParticle(particle);
					particle = particle.next;
				} while (particle);
			}
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			super.removeEventListener(type, listener, useCapture);
			updateWillTriggerFlags();
		}
		
		/*
		 * Removes a specified item from the array.
		 * 
		 * @internal Utility function
		 * 
		 * @param	array	The array to go through
		 * @param	item	The item to be removed
		 * @return A boolean whether it was successful or not
		 */
		/*public static function removeItem(array:Array, item:*):Boolean {
			var i:uint = array.length;
			while (i--) {
				if (array[i] === item) {
					array.splice(i, 1);
					return true;
				}
			}
			return false;
		}*/
		
		/**
		 * Updates all the particles and positions, updates the output class as well.
		 * 
		 * @param	e The event dispatched.
		 * @default null
		 */
		public function render(e:Event = null):void {
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
			
			var particle:ParticleVO = _particlesTest;
			var numAdd:uint = settings.numberOfParticles;
			trace("numAdd", numAdd);
			if (paused) particle = null;
			
			do {
				if (!particle.active) {
					addParticle(particle);// was point
					--numAdd;
				} else {
					// Too old
					if (settings.lifeSpan > 0) {
						if ((Orion.time - particle.timeStamp) > settings.lifeSpan) {
							removeParticle(particle);
							continue;
						}
					}
					
					// Paused
					if (!particle.paused) {
						// Apply Filters
						var i:uint = effectFilters.length;
						if(i > 0) {
							while (i--) {
								effectFilters[i].applyFilter(particle, this);
							}
						}
						
						if (particle.velocity[0] != 0) particle.target.x += particle.velocity[0] + denormal - denormal;
						if (particle.velocity[1] != 0) particle.target.y += particle.velocity[1] + denormal - denormal;
						if (particle.velocity[2] != 0 && particle.isDisplayObject) particle.target.rotation += particle.velocity[2] + denormal - denormal;
						if (edgeFilter) edgeFilter.applyFilter(particle, this);
					}
				}
				
				// Emit updaters
				emit2(updateEmitters);
				
				particle = particle.next;
			} while(particle);
			
			if ((_willTriggerFlags & 0x02) != 0)  dispatchEvent(_eventChange);
		}
		
		/**
		 * This acts as a fake output update function for use by the Update
		 * and Destroy emitters.
		 * 
		 * @param	emitter The emitter to be used.
		 */
		public function update(emitter:Orion):void {
			emit();
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		/**
		 * Adds a new particle to the system. Before creating a new particle, it will check the
		 * recycle bin of old particles to see if it can match the particle requested. If so, it
		 * will re-use an old particle rather than create a new one as this is quicker on the 
		 * player.
		 * 
		 * @param	pt The point to position the particle at.
		 * @default null (getCoordinate)
		 * 
		 * @param	c The class to be used for the particle.
		 * @default null (spriteClass)
		 * 
		 * @see Orion#getCoordinate()
		 * @see Orion#spriteClass
		 */
		protected function addParticle(p:ParticleVO, pt:Point = null):void {
			pt = pt || getCoordinate();
			if (pt) {
				_mtx.tx = pt.x;
				_mtx.ty = pt.y;
				
				p.active = true;
				p.paused = false;
				p.timeStamp = Orion.time;
				p.mass = settings.mass;
				
				if(settings.velocityXMin != settings.velocityXMax) {
					p.velocity[0] = randomRange(settings.velocityXMin, settings.velocityXMax);
				} else {
					p.velocity[0] = settings.velocityX;
				}
				
				if(settings.velocityYMin != settings.velocityYMax) {
					p.velocity[1] = randomRange(settings.velocityYMin, settings.velocityYMax);
				} else {
					p.velocity[1] = settings.velocityY;
				}
				
				var angle:Number = settings.velocityAngle;
				if(settings.velocityAngleMin != settings.velocityAngleMax) {
					angle = randomRange(settings.velocityAngleMin, settings.velocityAngleMax);
				}
				if (angle != 0) {
					angle *= DEG2RAD;
					// http://lab.polygonal.de/2007/07/18/fast-and-accurate-sinecosine-approximation/
					//always wrap input angle to -PI..PI
					if (angle < -PI) {
						angle += PI_M2;
					} else if (angle > PI) {
						angle -= PI_M2;
					}
					
					//compute sine
					var sin:Number, cos:Number;
					if (angle < 0) {
						sin = PI_4 * angle + PI_42 * angle * angle;
					} else {
						sin = PI_4 * angle - PI_42 * angle * angle;
					}
					
					//compute cosine: sin(x + PI/2) = cos(x)
					angle += PI_D2;
					if (angle > PI) angle -= PI_M2;
					
					if (angle < 0) {
						cos = PI_4 * angle + PI_42 * angle * angle;
					} else {
						cos = PI_4 * angle - PI_42 * angle * angle;
					}
					
					//var cos:Number = Math.cos(angle);
					//var sin:Number = Math.sin(angle);
					p.velocity[0] = (p.velocity[0]) * cos - (p.velocity[1]) * sin;
					p.velocity[1] = (p.velocity[1]) * cos + (p.velocity[0]) * sin;
				}
				
				// If it's a pixel and not a display object, a lot of this can be skipped
				if (p.isDisplayObject) {
					if(settings.velocityRotateMin != settings.velocityRotateMax) {
						p.velocity[2] = randomRange(settings.velocityRotateMin, settings.velocityRotateMax);
					} else {
						p.velocity[2] = settings.velocityRotate;
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
					if (scale != 1) _mtx.scale(scale, scale);
					
					var rotate:Number = settings.rotate;
					if(settings.rotateMin != settings.rotateMax) {
						rotate = randomRange(settings.rotateMin, settings.rotateMax);
					}
					// TODO: Make sure rotate() is working correctly. Might have to translate negative target's position, rotate then translate positive the target's position to rotate
					if (rotate != 0) _mtx.rotate(rotate * DEG2RAD);
					
					// Goto a random frame or the first frame
					var frame:int = 1;
					var frameLength:int = useFrameCaching ? _cacheFrames.length - 1 : 1;
					if (p.isMovieClip) frameLength = MovieClip(p.target).totalFrames;
					if (settings.selectRandomFrame) frame = int(randomRange(0, frameLength));
					if (p.currentFrame != frame) {
						if (useFrameCaching) {
							frame -= 1; // For arrays
							var bmp:Bitmap = Sprite(p.target).getChildAt(0) as Bitmap;
							bmp.bitmapData = _cacheFrames[frame].bitmapData;
							bmp.x = _cacheFrames[frame].boundsLeft;
							bmp.y = _cacheFrames[frame].boundsTop;
						} else if(p.isMovieClip) {
							MovieClip(p.target).gotoAndStop(frame);
						}
					}
					p.currentFrame = frame;
					
					// Update position/color
					p.target.transform.colorTransform = _clr;
					p.target.transform.matrix = _mtx;
				} else {
					// Update position
					p.target.x = _mtx.tx;
					p.target.y = _mtx.ty;
				}
				
				if(p.isDisplayObject) this.addChild(p.target as DisplayObject);
				
				emit2(createEmitters);
			}
		}
		
		/**
		 * If it's a movieclip, cache it's frames.
		 * 
		 * @param	mc The particle to have it's frames cached.
		 */
		protected function cacheFramesOf(mc:DisplayObject):void {
			var bounds:Rectangle, bmpData:BitmapData, matrix:Matrix, i:uint = (mc is MovieClip) ? MovieClip(mc).totalFrames : 1;
			_cacheTarget = mc;
			_cacheFrames = new Vector.<CacheFrameVO>(i, true);
			
			//var x:Number = 0;
			while (i--) {
				// << 1 is the same as * 2
				bounds = _cacheTarget.getBounds(_cacheTarget);
				matrix = RESET_MATRIX;
				matrix.translate(bounds.left << 1, bounds.top << 1);
				matrix.invert();
				// TODO: See if we can take better (smaller) snapshots 
				bmpData = new BitmapData(_cacheTarget.width << 1, _cacheTarget.height << 1, true, 0);
				bmpData.draw(_cacheTarget, matrix, RESET_COLORTRANSFORM, cacheBlendMode, null, cacheSmoothing);
				_cacheFrames.push(new CacheFrameVO(bmpData, bounds.left << 1, bounds.top << 1));
				if(_cacheTarget is MovieClip) MovieClip(_cacheTarget).nextFrame();
				
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
			
			if(_cacheTarget is MovieClip) MovieClip(_cacheTarget).gotoAndStop(1);
		}
		
		/**
		 * Removes a particle and stores the reference to the particle inside 
		 * of the recyclebin dictionary.
		 */
		protected function removeParticle(p:ParticleVO):void {
			emit2(destroyEmitters);
			p.active = false;
			if (p.isDisplayObject) this.removeChild(p.target as DisplayObject);
		}
		
		/**
		 * Checks the recycle bin if a suitable particle can be re-used.
		 * 
		 * @return	The particle
		 */
		protected function checkOutParticle():ParticleVO {
			if (_recycleBinlength == 0) {
				// Create new particle
				var d:Object;
				if (useFrameCaching) {
					if (_cacheFrames && _cacheFrames.length != 0) {
						// Init particle with reference of movieclip
						d = getCached();
					} else {
						d = getNew();
						if (d is DisplayObject) {
							cacheFramesOf(d as DisplayObject);
							d = getCached();
						} else {
							useFrameCaching = false;
							trace("Orion error! Cannot cache frames of designated SpriteClass. SpriteClass must be a Movieclip to cache frames : [" + _spriteClass + "]");
						}
					}
				} else {
					d = getNew();
					if(d is DisplayObject) {
						d.blendMode = cacheBlendMode;
						d.cacheAsBitmap = useCacheAsBitmap;
					}
				}
				
				return new ParticleVO(d);
			}
			
			return _recycleBin[--_recycleBinlength];
		}
		
		/**
		 * Calls emit for any other emitters
		 * 
		 * @param	emitters
		 * @param	p
		 */
		protected function emit2(emitters:Vector.<Orion>):void {
			var i:uint = emitters.length;
			if (i > 0) {
				_pt.x = _particle.target.x;
				_pt.y = _particle.target.y;
				while (i--) {
					emitters[i].emit(_pt);
				}
			}
		}
		
		protected function getCached():Sprite {
			// TODO: See if we can use just bitmap without sprite
			var spr:Sprite = new Sprite(), bmp:Bitmap = new Bitmap(_cacheFrames[0].bitmapData, cachePixelSnapping, cacheSmoothing);
			spr.addChild(bmp);
			bmp.x = _cacheFrames[0].boundsLeft;
			bmp.y = _cacheFrames[0].boundsTop;
			spr.blendMode = cacheBlendMode;
			spr.cacheAsBitmap = useCacheAsBitmap;
			return spr;
		}
		
		/**
		 * Returns a coordinate it's designated position.
		 * 
		 * @return Returns a coordinate at the emitters x,y position or within it.
		 */
		protected function getCoordinate():Point {
			_pt.x = randomRange(_emitter.left, _emitter.right);
			_pt.y = randomRange(_emitter.top, _emitter.bottom);
			return _pt;
		}
		
		protected function getNew():Object {
			return _spriteClass ? new _spriteClass() : new Point();
		}
		
		/*
		 * Sets a given particle to a specific frame in the movieclip, from
		 * the frame cached in memory.
		 * 
		 * @param	d The particle
		 * @param	frame The frame number to go to
		 */
		/*protected function gotoAndStopCached(p:ParticleVO, isRandom:Boolean = false):void {
			var frame:int = 1;
			var frameLength:int = useFrameCaching ? _cacheFrames.length - 1 : 1;
			if (p.isMovieClip) frameLength = MovieClip(p.target).totalFrames;
			if (isRandom) frame = int(randomRange(1, frameLength));
			
			if(p.currentFrame != frame) {
				if (useFrameCaching) {
					frame -= 1; // For arrays
					var bmp:Bitmap = Sprite(p.target).getChildAt(0) as Bitmap;
					bmp.bitmapData = _cacheFrames[frame].bitmapData;
					bmp.x = _cacheFrames[frame].boundsLeft;
					bmp.y = _cacheFrames[frame].boundsTop;
				} else if(p.isMovieClip) {
					MovieClip(p.target).gotoAndStop(frame);
				}
			}
			
			p.currentFrame = frame;
		}*/
		
		/**
		 * Resets the particle and initializes it for use.
		 * 
		 * @param	d The particle to be rendered and updated.
		 */
		protected function initParticle():void {
			_particle.paused = false;
			_particle.timeStamp = Orion.time;
			_particle.mass = settings.mass;
			
			if(settings.velocityXMin != settings.velocityXMax) {
				_particle.velocity[0] = randomRange(settings.velocityXMin, settings.velocityXMax);
			} else {
				_particle.velocity[0] = settings.velocityX;
			}
			
			if(settings.velocityYMin != settings.velocityYMax) {
				_particle.velocity[1] = randomRange(settings.velocityYMin, settings.velocityYMax);
			} else {
				_particle.velocity[1] = settings.velocityY;
			}
			
			var angle:Number = settings.velocityAngle;
			if(settings.velocityAngleMin != settings.velocityAngleMax) {
				angle = randomRange(settings.velocityAngleMin, settings.velocityAngleMax);
			}
			if (angle != 0) {
				angle *= DEG2RAD;
				// http://lab.polygonal.de/2007/07/18/fast-and-accurate-sinecosine-approximation/
				//always wrap input angle to -PI..PI
				if (angle < -PI) {
					angle += PI_M2;
				} else if (angle > PI) {
					angle -= PI_M2;
				}
				
				//compute sine
				var sin:Number, cos:Number;
				if (angle < 0) {
					sin = PI_4 * angle + PI_42 * angle * angle;
				} else {
					sin = PI_4 * angle - PI_42 * angle * angle;
				}
				
				//compute cosine: sin(x + PI/2) = cos(x)
				angle += PI_D2;
				if (angle > PI) angle -= PI_M2;
				
				if (angle < 0) {
					cos = PI_4 * angle + PI_42 * angle * angle;
				} else {
					cos = PI_4 * angle - PI_42 * angle * angle;
				}
				
				//var cos:Number = Math.cos(angle);
				//var sin:Number = Math.sin(angle);
				_particle.velocity[0] = (_particle.velocity[0]) * cos - (_particle.velocity[1]) * sin;
				_particle.velocity[1] = (_particle.velocity[1]) * cos + (_particle.velocity[0]) * sin;
			}
			
			// If it's a pixel and not a display object, a lot of this can be skipped
			if (_particle.isDisplayObject) {
				if(settings.velocityRotateMin != settings.velocityRotateMax) {
					_particle.velocity[2] = randomRange(settings.velocityRotateMin, settings.velocityRotateMax);
				} else {
					_particle.velocity[2] = settings.velocityRotate;
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
				if (scale != 1) _mtx.scale(scale, scale);
				
				var rotate:Number = settings.rotate;
				if(settings.rotateMin != settings.rotateMax) {
					rotate = randomRange(settings.rotateMin, settings.rotateMax);
				}
				// TODO: Make sure rotate() is working correctly. Might have to translate negative target's position, rotate then translate positive the target's position to rotate
				if (rotate != 0) _mtx.rotate(rotate * DEG2RAD);
				
				// Goto a random frame or the first frame
				var frame:int = 1;
				var frameLength:int = useFrameCaching ? _cacheFrames.length - 1 : 1;
				if (_particle.isMovieClip) frameLength = MovieClip(_particle.target).totalFrames;
				if (settings.selectRandomFrame) frame = int(randomRange(0, frameLength));
				if (_particle.currentFrame != frame) {
					if (useFrameCaching) {
						frame -= 1; // For arrays
						var bmp:Bitmap = Sprite(_particle.target).getChildAt(0) as Bitmap;
						bmp.bitmapData = _cacheFrames[frame].bitmapData;
						bmp.x = _cacheFrames[frame].boundsLeft;
						bmp.y = _cacheFrames[frame].boundsTop;
					} else if(_particle.isMovieClip) {
						MovieClip(_particle.target).gotoAndStop(frame);
					}
				}
				_particle.currentFrame = frame;
				
				// Update position/color
				_particle.target.transform.colorTransform = _clr;
				_particle.target.transform.matrix = _mtx;
			} else {
				// Update position
				_particle.target.x = _mtx.tx;
				_particle.target.y = _mtx.ty;
			}
			
			//_particles.unshift(p);
			_particles[_cursor] = _particle;
			++_cursor;
		}
		
		/**
		 * Return a random number between a range of numbers
		 * 
		 * @internal Utility function
		 * 
		 * @param	min<Number> The minimum number in the range
		 * @param	max<Number> The maximum number in the range
		 * @return A random number between the two numbers given.
		 */
		protected static function randomRange(min:Number, max:Number):Number {
			if (min == max) return min;
			return Math.random() * (max - min) + min;
		}
		
		protected function updateWillTriggerFlags():void {
			// Use, for each one, multiply by two, so the next would be 0x04
			if (this.willTrigger(Event.RESIZE)) {
				_willTriggerFlags |= 0x01;
			} else {
				_willTriggerFlags &= ~0x01;
			}
			
			if (this.willTrigger(Event.CHANGE)) {
				_willTriggerFlags |= 0x02;
			} else {
				_willTriggerFlags &= ~0x02;
			}
		}
		
		/**
		 * This is called each time the reference shape enters a new frame.
		 * 
		 * @param	e
		 */
		private static function tick(e:Event):void {
			Orion.time = getTimer();
			_shape.dispatchEvent(_eventTick);
		}
	}
}