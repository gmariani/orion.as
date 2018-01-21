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

package cv {
	
	import cv.orion.interfaces.IFilter;
	import cv.orion.interfaces.IOutput;
	import cv.orion.ParticleVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
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
	 * import cv.Orion;
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
		public static const DEG2RAD:Number = Math.PI / 180;
		
		/**
		 * The current version of Orion.
		 */
		public static const VERSION:String = "1.0.0";
		
		/**
		 * Current Time
		 */
		public static var time:int;
		
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
		 * This array can only accept instances of the Orion class.
		 * 
		 * When using this, specify the output of the child emitter to the parent emitter.
		 */
		public var createEmitters:Array = new Array();
		
		/**
		 * Turns on debug lines to outline the emitter and canvas dimensions
		 */
		public var debug:Boolean = false;
		
		/**
		 * Triggers the emitters everytime a particle from this emitter
		 * is destroyed. This allows for effects like the explosion after a firework goes up.
		 * 
		 * This array can only accept instances of the Orion class.
		 * 
		 * When using this, specify the output of the child emitter to the parent emitter.
		 */
		public var destroyEmitters:Array = new Array();
		
		/**
		 * Gets or sets the edge filter used by the emitter to determine what the particles
		 * will do when they hit the edge. Pass nothing to it in order to reset it.
		 */
		public var edgeFilter:IFilter;
		
		/**
		 * Gets the filters being applied by the emitter.
		 */
		public var effectFilters:Array = new Array();
		
		/**
		 * As the particles are updated, this will toggle visibility on or off.
		 * Used by the BitmapRenderer/PixelRenderer so it can hide the particles
		 * without additional overhead.
		 */
		public var particlesVisible:Boolean = true;
		
		/**
         * Gets or sets the output class used. The default is the <code>null</code>.
		 */
		public var output:IOutput;
		
		/**
		 * The settings object controls all configuration. The settings object can contain the following properties :
		 * <br/><br/>
		 * <ul>
		 * <li> lifeSpan:int - The lifespan of the particle in milliseconds. After that time is up, it is removed from display. (In milliseconds)
		 * <li> mass:Number - The mass of a particle. The larger, the harder it is to move.
		 * <li> opacity:Number - The initial alpha of a particle. From 0 to 1.
		 * <li> opacityMin:Number - The minimum alpha in a range for the particle randomly initially. From 0 to 1.
		 * <li> opacityMax:Number - The maximum alpha in a range for the particle randomly initially. From 0 to 1.
		 * <li> velocityX:Number - The initial X velocity of a particle.
		 * <li> velocityXMin:Number - The minimum X velocity in a range to move the particle randomly initially.
		 * <li> velocityXMax:Number - The maximum X velocity in a range to move the particle randomly initially.
		 * <li> velocityY:Number - The initial Y velocity of a particle.
		 * <li> velocityYMin:Number - The minimum Y velocity in a range to move the particle randomly initially.
		 * <li> velocityYMax:Number - The maximum Y velocity in a range to move the particle randomly initially.
		 * <li> velocityRotate:Number - The initial spinning velocity of a particle.
		 * <li> velocityRotateMin:Number - The minimum spin in a range to spin the particle randomly initially.
		 * <li> velocityRotateMax:Number - The maximum spin in a range to spin the particle randomly initially.
		 * <li> velocityAngle:Number - The direction the particle will move in. From 0 to 360.
		 * <li> velocityAngleMin:Number - The minimum angle in a range to move in a random direction. From 0 to 360.
		 * <li> velocityAngleMax:Number - The maximum angle in a range to move in a random direction. From 0 to 360.
		 * <li> rotate:Number - The initial rotation of a particle. From 0 to 360.
		 * <li> rotateMin:Number - The minimum rotation in a range to rotate the particle randomly initially. From 0 to 360.
		 * <li> rotateMax:Number - The maximum rotation in a range to rotate the particle randomly initially. From 0 to 360.
		 * <li> scale:Number - The initial scale of a particle.
		 * <li> scaleMin:Number - The minimum scale in a range to scale the particle randomly initially.
		 * <li> scaleMax:Number - The maximum scale in a range to scale the particle randomly initially.
		 * <li> color:int - The initial tint of a particle.
		 * <li> colorMin:int - The minimum color in a range to tint the particle randomly initially.
		 * <li> colorMax:int - The maximum color in a range to tint the particle randomly initially.
		 * <li> selectRandomFrame:Boolean - If a frame is randomly selected initially.
		 * <li> numberOfParticles:Number - How many particles to create each time a particle is emitted.
		 * </ul>
		 */
		public var settings:Object = new Object();
		
		/**
		 * Triggers the emitters everytime a particle from this emitter
		 * gets updated. This allows for effects like trailing smoke of a particle.
		 * 
		 * This array can only accept instances of the Orion class.
		 * 
		 * When using this, specify the output of the child emitter to the parent emitter.
		 */
		public var updateEmitters:Array = new Array();
		
		/**
		 * Gets or sets whether bitmap caching is enabled on particles used within this emitter. 
		 * If set to true, Flash Player or Adobe AIR caches an internal bitmap representation of 
		 * the display object. This caching can increase performance for display objects that 
		 * contain complex vector content.
		 */
		public var useCacheAsBitmap:Boolean = false;
		
		/** @private */
		protected var _cacheFrames:Array;
		/** @private */
		protected var _cacheTarget:MovieClip;
		/** @private */
		protected var _clr:ColorTransform = new ColorTransform();
		/** @private */
		protected var _coordPoint:Point = new Point();
		/** @private */
		protected var _emitter:Rectangle = new Rectangle();
		/** @private */
		protected static var _eventChange:Event;
		/** @private */
		protected static var _eventResize:Event;
		/** @private */
		protected static var _eventTick:Event;
		/** @private */
		protected static var _particles:Dictionary = new Dictionary();
		/** @private */
		protected var _paused:Boolean = false;
		/** @private */
		protected static var _shape:Shape = new Shape(); //A reference to the sprite that we use to drive all our ENTER_FRAME events.
		/** @private */
		protected var _spriteClass:Class;
		/** @private **/
		protected static var _timer:Timer = new Timer(2000);
		/** @private */
		protected var _useFrameCaching:Boolean = false;
		
		/**
		 * The constructor allows a few common settings to be specified during construction. Options such
		 * as the output class or any configuration settings.
		 * 
		 * @param	spriteClass This is the linkage class of the item you have exported from the library.
		 * @param	output	Here you can specify which output class you'd like to use. If you don't want to 
		 * use one, just leave this as <code>null</code>
		 * @param	config	Here you can pass in a <code>configuration</code> object. A <code>configuration</code> object is generated by a 
		 * preset or you can write one by hand. Each <code>configuration</code> object can contain an <code>effectFilters</code> array, an
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
			_particles[this] = new Array();
			_spriteClass = spriteClass;
			
			// Init Settings
			this.useFrameCaching = useFrameCaching;
			this.output = output;
			applyPreset(config);
			
			// Init static settings
			if(!_eventChange) _eventChange = new Event(Event.CHANGE);
			if(!_eventResize) _eventResize = new Event(Event.RESIZE);
			if(!_eventTick) _eventTick = new Event("tick");
			if(!_shape.hasEventListener(Event.ENTER_FRAME)) _shape.addEventListener(Event.ENTER_FRAME, tick, false, 0, true);
			_shape.addEventListener("tick", render, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER, killGarbage, false, 0, true);
			_timer.start();
			
			// Init stage listener
			this.addEventListener(Event.ADDED_TO_STAGE, stageHandler, false, 0, true);
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * The storage location for frames that are cached. Used by filters and emitters.
		 */
		public function get cacheFrames():Array { return _cacheFrames; }
		
		/**
		 * Gets the frame cache movieclip. This is the movieclip that has had
		 * it's frames cached.
		 */
		public function get cacheTarget():MovieClip { return _cacheTarget; }
		
		/**
		 * Gets or sets the height of the emitter.
		 */
		override public function get height():Number { return _emitter.height; }
		/** @private **/
		override public function set height(value:Number):void {
			_emitter.height = value;
			if (hasEventListener(Event.RESIZE)) dispatchEvent(_eventResize);
		}
		
		/**
		 * The array of all the particles in this instance of Orion
		 */
		public function get particles():Array { return _particles[this]; }
		
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
			_cacheTarget = null;
			_cacheFrames = null;
		}
		
		/**
		 * Gets or sets whether frame caching will be enabled. Frame caching takes a snapshot
		 * of each frame of a movieclip and stores the bitmaps in an array. This bitmapdata is
		 * used later for new particles. This can greatly improve performance on occasion (especially
		 * movieclips with lots of fiters used inside or multiple frames).
		 */
		public function get useFrameCaching():Boolean { return _useFrameCaching; }
		/** @private **/
		public function set useFrameCaching(value:Boolean):void {
			_useFrameCaching = value;
			removeAllParticles();
		}
		
		/**
		 * Gets or sets the width of the emitter.
		 */
		override public function get width():Number { return _emitter.width; }
		/** @private **/
		override public function set width(value:Number):void {
			_emitter.width = value;
			if (hasEventListener(Event.RESIZE)) dispatchEvent(_eventResize);
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
		
		public function applyPreset(config:Object = null, reset:Boolean = false):void {
			if (reset) {
				this.edgeFilter = null;
				this.effectFilters = new Array();
				this.settings = new Object();
			}
			
			if(config) {
				if (config.hasOwnProperty("effectFilters") && config.effectFilters is Array) this.effectFilters = config.effectFilters;
				if (config.hasOwnProperty("settings") && config.settings is Object) this.settings = config.settings;
				if (config.hasOwnProperty("edgeFilter")) this.edgeFilter = config.edgeFilter;
			}
			
			if (!this.settings.hasOwnProperty("lifeSpan")) this.settings.lifeSpan = 5000;
			if (!this.settings.hasOwnProperty("mass")) this.settings.mass = 1;
		}
		
		/**
		 * Causes the emitter to add particles.
		 * 
		 * @param	point	Where to position the particle
		 * @param	numberOfParticles How many particles are emitted during each emit&#40;&#41; call.
		 */
		public function emit(point:Point = null):void {
			if (paused) return;
			if (!settings.hasOwnProperty("numberOfParticles")) {
				addParticle(point);
			} else {
				var i:int = settings.numberOfParticles;
				while (i--) {
					addParticle(point);
				}
			}
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
		 * Finds a ColorTransform that's between the two ColorTransforms given.
		 * 
		 * @internal Utility function
		 * 
		 * @param	fromColor<ColorTransform> The first ColorTransform
		 * @param	toColor<ColorTransform> The second ColorTransform
		 * @param	progress<Number> The ratio between the two ColorTransforms you want returned.
		 * @return The ColorTransform between the two ColorTransforms.
		 */
		public static function interpolateTransform(fromColor:ColorTransform, toColor:ColorTransform, progress:Number):ColorTransform {
			var n:Number = progress, r:Number = 1 - n, sc:Object = fromColor, ec:Object = toColor;
			return new ColorTransform(sc.redMultiplier * r + ec.redMultiplier * n,
									    sc.greenMultiplier * r + ec.greenMultiplier * n,
									    sc.blueMultiplier * r + ec.blueMultiplier * n,
									    sc.alphaMultiplier * r + ec.alphaMultiplier * n,
									    sc.redOffset * r + ec.redOffset * n,
									    sc.greenOffset * r + ec.greenOffset * n,
									    sc.blueOffset * r + ec.blueOffset * n,
									    sc.alphaOffset * r + ec.alphaOffset * n);
		}
		
		/**
		 * This will run ever 2 seconds and remove any inactive particles from memory.
		 * 
		 * @param	e The event dispatched.
		 * @default null
		 */
		public function killGarbage(e:TimerEvent = null):void {
			var i:int = _particles[this].length;
			while (i--) {
				if (!_particles[this][i].active) {
					_particles[this].pop();
				} else {
					break;
				}
			}
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
			var i:int = _particles[this].length;
			while (i--) {
				removeParticle(_particles[this][i], false);
			}
			_particles[this] = new Array();
		}
		
		/**
		 * Removes a specified item from the array.
		 * 
		 * @internal Utility function
		 * 
		 * @param	array	The array to go through
		 * @param	item	The item to be removed
		 * @return A boolean whether it was successful or not
		 */
		public static function removeItem(array:Array, item:*):Boolean {
			var i:uint = array.length;
			while (i--) {
				if (array[i] === item) {
					array.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Updates all the particles and positions, updates the output class as well.
		 * 
		 * @param	e The event dispatched.
		 * @default null
		 */
		public function render(e:Event = null):void {
			// Draw boxes for emitter and canvas
			this.graphics.clear();
			if (debug) {
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
			
			if (spriteClass) {
				var i:int = _particles[this].length;
				while (i--) {
					if(_particles[this][i].active == true) renderParticle(_particles[this][i]);
				}
				
				if (output) {
					output.update(this);
				} else {
					emit();
				}
			}
			
			if (hasEventListener(Event.CHANGE)) dispatchEvent(_eventChange);
		}
		
		/**
		 * Takes a given coordinate and rotates it in a 2D space. This is used
		 * for calculations like collosions detection.
		 * 
		 * @internal Utility function
		 * 
		 * @param	x<Number> The x coordinate
		 * @param	y<Number> The y coordinate
		 * @param	sin<Number> The sine of the angle to rotate
		 * @param	cos<Number> The cosine of the angle to rotate
		 * @param	reverse<Number> Which direction to rotate
		 * @return The adjusted point after rotation.
		 */
		public static function rotateCoord(x:Number, y:Number, sin:Number, cos:Number):Point {
			var pt:Point = new Point();
			pt.x = x * cos - y * sin;
			pt.y = y * cos + x * sin;
			return pt;
		}
		
		/**
		 * This acts as a fake output update function for use by the Update
		 * and Destroy emitters.
		 * 
		 * @param	emitter The emitter to be used.
		 */
		public function update(emitter:Orion):void {
			// Do Nothing
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
		protected function addParticle(pt:Point = null):void {
			pt = pt || getCoordinate();
			if (pt) {
				var p:ParticleVO = (_particles[this].length > 0 && _particles[this][_particles[this].length - 1].active == false) ? getRecycled() : getNew();
				var d:DisplayObject = p.target;
				d.x = pt.x;
				d.y = pt.y;
				d.scaleX = d.scaleY = 1;
				d.alpha = 1;
				d.rotation = 0;
				
				resetParticle(p);
				
				this.addChild(d);
				
				// Emit creators
				var i:int = createEmitters.length;
				if (i > 0) {
					while (i--) {
						createEmitters[i].emit(new Point(d.x, d.y));
					}
				}
			}
		}
		
		/**
		 * Sets a given particle to a specific frame in the movieclip, from
		 * the frame cached in memory.
		 * 
		 * @param	d The particle
		 * @param	frame The frame number to go to
		 */
		protected function gotoAndStopCached(d:DisplayObject, frame:int):void {
			var bmp:Bitmap = Sprite(d).getChildAt(0) as Bitmap;
			bmp.bitmapData = _cacheFrames[frame][0];
			bmp.x = _cacheFrames[frame][1];
			bmp.y = _cacheFrames[frame][2];
		}
		
		/**
		 * If it's a movieclip, cache it's frames.
		 * 
		 * @param	mc The particle to have it's frames cached.
		 */
		protected function cacheFramesOf(mc:MovieClip):void {
			_cacheTarget = mc;
			_cacheFrames = new Array();
			
			var bounds:Rectangle, bmpData:BitmapData, matrix:Matrix;
			var cTransform:ColorTransform = new ColorTransform(1, 1, 1);
			var i:int = _cacheTarget.totalFrames;
			//var x:Number = 0;
			while (i--) {
				bounds = _cacheTarget.getBounds(_cacheTarget);
				matrix = new Matrix();
				matrix.translate(bounds.left * 2, bounds.top * 2);
				matrix.invert();
				
				bmpData = new BitmapData(_cacheTarget.width * 2, _cacheTarget.height * 2, true, 0);
				bmpData.draw(_cacheTarget, matrix, cTransform, cacheBlendMode, null, cacheSmoothing);
				_cacheFrames.push([bmpData, bounds.left * 2, bounds.top * 2]);
				_cacheTarget.nextFrame();
				
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
			
			_cacheTarget.gotoAndStop(1);
		}
		
		/**
		 * Used to get a colortransform object for a specific particle.
		 * 
		 * @internal Utility function
		 * 
		 * @param	d The particle to be recycled
		 * @return	The given colortransform object
		 */
		protected function getColorTransform(p:ParticleVO, targetColor:uint):ColorTransform {
			return new ColorTransform(((targetColor >>> 16) & 255) / 255, ((targetColor >>> 8) & 255) / 255, (targetColor & 255) / 255, 1, 0,0,0,0);
			//return = new ColorTransform(((p.color >>> 16) & 255) / 255, ((p.color >>> 8) & 255) / 255, (p.color & 255) / 255, ((p.color >>> 24) & 255) / 255, 0,0,0,0);
		}
		
		/**
		 * Returns a coordinate it's designated position.
		 * 
		 * @return Returns a coordinate at the emitters x,y position or within it.
		 */
		protected function getCoordinate():Point {
			_coordPoint.x = (_emitter.width <= 1) ? _emitter.x : randomRange(_emitter.left, _emitter.right);
			_coordPoint.y = (_emitter.height <= 1) ? _emitter.y : randomRange(_emitter.top, _emitter.bottom);
			return _coordPoint;
		}
		
		/**
		 * Returns a new particle
		 * 
		 * @return	The particle
		 */
		protected function getNew():ParticleVO {
			var d:DisplayObject = new _spriteClass();
			if (useFrameCaching) {
				if (d is MovieClip) {
					cacheFramesOf(d as MovieClip);
				} else {
					useFrameCaching = false;
					trace("Orion error! Cannot cache frames of designated sprite class. Sprite class must be a movieclip to cache frames", _spriteClass);
				}
				if(_cacheFrames) {
					// Init particle with reference of movieclip
					d = new Sprite();
					var bmp:Bitmap = new Bitmap(_cacheFrames[0][0], cachePixelSnapping, cacheSmoothing);
					Sprite(d).addChild(bmp);
					bmp.x = _cacheFrames[0][1];
					bmp.y = _cacheFrames[0][2];
				}
			}
			
			var p:ParticleVO = new ParticleVO();
			p.target = d;
			p.velocity = new Point();
			
			d.blendMode = cacheBlendMode;
			d.cacheAsBitmap = useCacheAsBitmap;
			
			return p;
		}
		
		/**
		 * Checks the recycle bin if a suitable particle can be re-used.
		 * 
		 * @return	The particle
		 */
		protected function getRecycled():ParticleVO {
			return _particles[this].pop();
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
			return Math.random() * (max - min) + min;
		}
		
		/**
		 * Removes a particle and stores the reference to the particle inside 
		 * of the recyclebin dictionary.
		 * 
		 * @param	d The particle to be recycled
		 */
		protected function recycleParticle(p:ParticleVO):void {
			removeParticle(p);
			_particles[this].push(p);
		}
		
		/**
		 * Removes a particle. This is typically called during the garbage 
		 * collection phase of a particle's life.
		 * 
		 * @param	d The particle to be removed.
		 * @param	doArray Whether to remove from the particle array or not.
		 */
		protected function removeParticle(p:ParticleVO, doArray:Boolean = true):void {
			p.active = false;
			p.paused = false;
			
			// Emit destroyers
			var i:int = destroyEmitters.length;
			if (i > 0) {
				while (i--) {
					destroyEmitters[i].emit(new Point(p.target.x, p.target.y));
				}
			}
			
			//if (destroyEmitter) destroyEmitter.emit(new Point(p.target.x, p.target.y));
			if (p.target.parent) p.target.parent.removeChild(p.target);
			if (doArray) removeItem(_particles[this], p);
		}
		
		/**
		 * Updates the specific particle based on the filters assigned to the emitter.
		 * Also handles any garbage clean up.
		 * 
		 * @param	d The particle to be rendered and updated.
		 */
		protected function renderParticle(p:ParticleVO):void {
			var d:DisplayObject = p.target;
			// Too small to see
			if (d.width < 1 || d.height < 1 || d.alpha < 0.02) {
				recycleParticle(p);
				return;
			}
			
			// Too old
			if (settings.lifeSpan >= 0) {
				if ((time - p.timeStamp) > settings.lifeSpan) {
					recycleParticle(p);
					return;
				}
			}
			
			if (p.active == false || p.paused == true) return;
			
			p.target.visible = particlesVisible;
			
			// Apply Filters
			var i:int = effectFilters.length;
			if(i > 0) {
				while (i--) {
					effectFilters[i].applyFilter(p, this);
				}
			}
			
			if (p.velocity.x != 0) d.x += p.velocity.x;
			if (p.velocity.y != 0) d.y += p.velocity.y;
			if (p.angularVelocity != 0) d.rotation += p.angularVelocity;
			if (edgeFilter) edgeFilter.applyFilter(p, this);
			
			// Emit updaters
			i = updateEmitters.length;
			if (i > 0) {
				while (i--) {
					updateEmitters[i].emit(new Point(d.x, d.y));
				}
			}
		}
		
		/**
		 * Resets the particle and initializes it for use.
		 * 
		 * @param	d The particle to be rendered and updated.
		 */
		protected function resetParticle(p:ParticleVO):void {
			var d:DisplayObject = p.target;
			p.angularVelocity = 0;
			p.active = true;
			p.paused = false;
			p.velocity.x = 0;
			p.velocity.y = 0;
			p.timeStamp = time;
			p.mass = settings.hasOwnProperty("mass") ? settings.mass : 1;
			
			_clr.alphaMultiplier = d.alpha;
			if(settings.hasOwnProperty("colorMin") && settings.hasOwnProperty("colorMax")) {
				_clr.color = interpolateColor(settings.colorMin, settings.colorMax, Math.random());
				d.transform.colorTransform = _clr;
			} else if (settings.hasOwnProperty("color")) {
				_clr.color = settings.color;
				d.transform.colorTransform = _clr;
			}
			
			if(settings.hasOwnProperty("alphaMin") && settings.hasOwnProperty("alphaMax")) {
				d.alpha = randomRange(settings.alphaMin, settings.alphaMax);
			} else if (settings.hasOwnProperty("alpha")) {
				d.alpha = settings.alpha;
			}
			
			if(settings.hasOwnProperty("velocityXMin") && settings.hasOwnProperty("velocityXMax")) {
				p.velocity.x = randomRange(settings.velocityXMin, settings.velocityXMax);
			} else if (settings.hasOwnProperty("velocityX")) {
				p.velocity.x = settings.velocityX;
			}
			
			if(settings.hasOwnProperty("velocityYMin") && settings.hasOwnProperty("velocityYMax")) {
				p.velocity.y = randomRange(settings.velocityYMin, settings.velocityYMax);
			} else if (settings.hasOwnProperty("velocityY")) {
				p.velocity.y = settings.velocityY;
			}
			
			if(settings.hasOwnProperty("velocityRotateMin") && settings.hasOwnProperty("velocityRotateMax")) {
				p.angularVelocity = randomRange(settings.velocityRotateMin, settings.velocityRotateMax);
			} else if (settings.hasOwnProperty("velocityRotate")) {
				p.angularVelocity = settings.velocityRotate;
			}
			
			var angle:Number = 0;
			if(settings.hasOwnProperty("velocityAngleMin") && settings.hasOwnProperty("velocityAngleMax")) {
				angle = randomRange(settings.velocityAngleMin, settings.velocityAngleMax);
			} else if (settings.hasOwnProperty("velocityAngle")) {
				angle = settings.velocityAngle;
			}
			if (angle != 0) {
				angle = angle * DEG2RAD;
				p.velocity = rotateCoord(p.velocity.x, p.velocity.y, Math.sin(angle), Math.cos(angle));
			}
			
			if(settings.hasOwnProperty("scaleMin") && settings.hasOwnProperty("scaleMax")) {
				d.scaleX = d.scaleY = randomRange(settings.scaleMin, settings.scaleMax);
			} else if (settings.hasOwnProperty("scale")) {
				d.scaleX = d.scaleY = settings.scale;
			}
			
			if(settings.hasOwnProperty("rotateMin") && settings.hasOwnProperty("rotateMax")) {
				d.rotation = randomRange(settings.rotateMin, settings.rotateMax);
			} else if (settings.hasOwnProperty("rotate")) {
				d.rotation = settings.rotate;
			}
			
			if(settings.hasOwnProperty("selectRandomFrame")) {
				if(useFrameCaching) {
					gotoAndStopCached(d, int(randomRange(0, (_cacheTarget.totalFrames - 1))));
				} else {
					if(d is MovieClip) MovieClip(d).gotoAndStop(int(randomRange(1, MovieClip(d).totalFrames)));
				}
			} else {
				if (useFrameCaching) {
					gotoAndStopCached(d, 0);
				} else {
					if(d is MovieClip) MovieClip(d).gotoAndStop(1);
				}
			}
			
			_particles[this].unshift(p);
		}
		
		/**
		 * The stage handler, this listens for the Event.ADDED_TO_STAGE event,
		 * so it knows when it can access the stage property. If the emitter is
		 * not part of the display list, it will automatically pause itself.
		 * 
		 * @param	e The event dispatched.
		 */
		protected function stageHandler(e:Event):void {
			if (e.type == Event.ADDED_TO_STAGE) {
				this.removeEventListener(Event.ADDED_TO_STAGE, stageHandler);
				this.addEventListener(Event.REMOVED_FROM_STAGE, stageHandler, false, 0, true);
			} else {
				paused = true;
				this.removeEventListener(Event.REMOVED_FROM_STAGE, stageHandler);
				this.addEventListener(Event.ADDED_TO_STAGE, stageHandler, false, 0, true);
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