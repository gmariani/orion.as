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

package cv.orion {
	
	import cv.geom.Vector;
	import cv.orion.interfaces.IFilter;
	import cv.orion.interfaces.IOutput;
	import cv.orion.ParticleVO;
	import cv.orion.SettingsVO;
	import cv.orion.events.ParticleEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
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
		
		/**
		 * The current version of Orion.
		 */
		public static const VERSION:String = "1.5.0";
		
		/** @private */
		protected static const _eventChange:Event = new Event(Event.CHANGE);
		/** @private */
		protected static const _eventResize:Event = new Event(Event.RESIZE);
		/** @private */
		protected static const _eventDied:ParticleEvent = new ParticleEvent(ParticleEvent.DIED);
		/** @private */
		protected static const _eventUpdate:ParticleEvent = new ParticleEvent(ParticleEvent.UPDATE);
		/** @private */
		protected static const _eventBorn:ParticleEvent = new ParticleEvent(ParticleEvent.BORN);
		/** @private */
		protected static const _eventTick:Event = new Event("tick");
		/** @private */
		protected static const _shape:Shape = new Shape(); //A reference to the sprite that we use to drive all our ENTER_FRAME events.
		/** @private */
		protected const _mtx:Matrix = new Matrix();
		/** @private */
		protected const _pt:Point = new Point();
		/** @private */
		protected const _emitter:Rectangle = new Rectangle();
		/** @private */
		protected const _emitQueue:Vector.<EmitVO> = new Vector.<EmitVO>();
		
		/**
		 * Current Time
		 */
		public static var time:uint;
		
		/**
		 * The canvas is used to control the boundaries (edge filter) of the particles animating.
		 */
		public var canvas:Rectangle;
		
		/**
		 * Turns on debug lines to outline the emitter and canvas dimensions
		 */
		public var debug:Boolean = false;
		
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
		 * The settings object controls all configuration. The settings object can contain the following properties :
		 */
		public var settings:SettingsVO = new SettingsVO();
		
		/** @private */
		protected var _numParticles:uint = 0;
		/** @private */
		protected var _particles:ParticleVO;
		/** @private */
		protected var _dispatchUpdates:Boolean = false;
		/** @private */
		protected var _paused:Boolean = false;
		/** @private */
		protected var _willTriggerFlags:uint = 0;
		/** @private */
		protected var _output:IOutput;
		
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
		public function Orion(config:Object = null) {
			_output = this;
			
			// Init Settings
			applyPreset(config);
			
			// Init static settings
			if(!_shape.hasEventListener(Event.ENTER_FRAME)) _shape.addEventListener(Event.ENTER_FRAME, tick, false, 0, true);
			_shape.addEventListener("tick", render, false, 0, true);
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * Gets or sets the height of the emitter.
		 */
		override public function get height():Number { return _emitter.height; }
		/** @private **/
		override public function set height(value:Number):void {
			_emitter.height = value;
			if ((_willTriggerFlags & 0x01) != 0) dispatchEvent(_eventResize);
		}
		
		public function get numParticles():uint { return _numParticles; }
		
		/**
         * Gets or sets the output class used. The default is the <code>null</code>.
		 */
		public function get output():IOutput { return _output; }
		/** @private **/
		public function set output(value:IOutput):void { _output = value || this; }
		
		/**
		 * The vector of all the particles in this instance of Orion
		 */
		public function get particles():ParticleVO { return _particles; }
		
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
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			updateWillTriggerFlags();
		}
		
		public function applyPreset(config:Object = null, reset:Boolean = false):void {
			if (reset) {
				this.edgeFilter = null;
				this.output = this;
				this.effectFilters = new Vector.<IFilter>();
				this.settings = new SettingsVO();
			}
			
			if(config) {
				if (config.hasOwnProperty("output") && config.output is IOutput) this.output = config.output;
				if (config.hasOwnProperty("effectFilters") && config.effectFilters is Vector.<IFilter>) this.effectFilters = config.effectFilters;
				if (config.hasOwnProperty("settings") && config.settings is SettingsVO) this.settings = config.settings;
				if (config.hasOwnProperty("edgeFilter")) this.edgeFilter = config.edgeFilter;
			}
		}
		
		public function createAllParticles():void { }
		
		/**
		 * Used to force a particle to emit and at a specified location
		 * 
		 * @param	coord
		 * @param	numParticles
		 */
		public function emit(coord:Point, numParticles:uint = 1):void {
			_emitQueue.push(new EmitVO(coord, numParticles));
		}
		
		/**
		 * This acts as a fake output update function for use by the Update
		 * and Destroy emitters.
		 * 
		 * @param	emitter The emitter to be used.
		 */
		public function getOutput(emitter:Orion):uint {
			return settings.numberOfParticles;
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
			var particle:ParticleVO = _particles;
			if(particle) {
				do {
					removeParticle(particle);
					particle = particle.next;
				} while (particle);
			}
			_particles = createParticle();
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			super.removeEventListener(type, listener, useCapture);
			updateWillTriggerFlags();
		}
		
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
			
			if (paused) return;
			
			_numParticles = length;
			
			if ((_willTriggerFlags & 0x02) != 0)  dispatchEvent(_eventChange);
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
		protected function addParticle(p:ParticleVO, pt:Point = null):Boolean {
			var pt:Point = pt || getCoordinate();
			if (pt) {
				_mtx.tx = pt.x;
				_mtx.ty = pt.y;
				
				p.active = true;
				p.paused = false;
				p.timeStamp = Orion.time;
				p.mass = settings.mass;
				
				if(settings.velocityXMin != settings.velocityXMax) {
					p.velocityX = randomRange(settings.velocityXMin, settings.velocityXMax);
				} else {
					p.velocityX = settings.velocityX;
				}
				
				if(settings.velocityYMin != settings.velocityYMax) {
					p.velocityY = randomRange(settings.velocityYMin, settings.velocityYMax);
				} else {
					p.velocityY = settings.velocityY;
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
					var sin:Number, cos:Number, x:Number;
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
					x = p.velocityX;
					p.velocityX = x * cos - p.velocityY * sin;
					p.velocityY = p.velocityY * cos + x * sin;
				}
				
				additionalInit(p, pt);
				
				if ((_willTriggerFlags & 0x04) != 0) {
					_eventBorn.particle = p;
					dispatchEvent(_eventBorn);
				}
				return true;
			}
			return false;
		}
		
		protected function additionalInit(p:ParticleVO, pt:Point):void { }
		
		protected function createParticle(idx:int = 0):ParticleVO {
			return new ParticleVO();
		}
		
		/**
		 * Removes a particle and stores the reference to the particle inside 
		 * of the recyclebin dictionary.
		 */
		protected function removeParticle(p:ParticleVO):void {
			p.active = false;
			if ((_willTriggerFlags & 0x10) != 0) {
				_eventDied.particle = p;
				dispatchEvent(_eventDied);
			}
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
		protected static function interpolateColor(fromColor:uint, toColor:uint, progress:Number):uint {
			var n:Number = 1 - progress; // Alpha
			var red:uint = uint(((fromColor >>> 16) & 255) * progress + ((toColor >>> 16) & 255) * n);
			var green:uint = uint(((fromColor >>> 8) & 255) * progress + ((toColor >>> 8) & 255) * n);
			var blue:uint = uint(((fromColor) & 255) * progress + ((toColor) & 255) * n);
			var alpha:uint = uint(((fromColor >>> 24) & 255) * progress + ((toColor >>> 24) & 255) * n);
			return (alpha << 24) | (red << 16) | (green << 8) | blue;
		}
		
		protected function updateWillTriggerFlags():void {
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
			
			if (this.willTrigger(ParticleEvent.BORN)) {
				_willTriggerFlags |= 0x04;
			} else {
				_willTriggerFlags &= ~0x04;
			}
			
			if (this.willTrigger(ParticleEvent.UPDATE)) {
				_willTriggerFlags |= 0x08;
			} else {
				_willTriggerFlags &= ~0x08;
			}
			_dispatchUpdates = ((_willTriggerFlags & 0x08) != 0);
			
			if (this.willTrigger(ParticleEvent.DIED)) {
				_willTriggerFlags |= 0x10;
			} else {
				_willTriggerFlags &= ~0x10;
			}
		}
		
		/**
		 * This is called each time the reference shape enters a new frame.
		 * 
		 * @param	e
		 */
		protected static function tick(e:Event):void {
			Orion.time = getTimer();
			_shape.dispatchEvent(_eventTick);
		}
	}
}