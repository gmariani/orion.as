////////////////////////////////////////////////////////////////////////////////
//
//  COURSE VECTOR - GABRIEL MARIANI
//  Copyright 2008 Gabriel Mariani
//  All Rights Reserved.
//
//  NOTICE: Course Vector permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package cv.orion.emitters {
	
	import cv.Orion;
	import cv.orion.events.ParticleEvent;
	import cv.orion.Particle;
	import cv.orion.interfaces.IEdgeFilter;
	import cv.orion.interfaces.IFilter;
	import cv.orion.interfaces.IRenderer;
	import cv.orion.interfaces.IOutput;
	import cv.orion.renderers.DisplayObjectRenderer;
	import cv.orion.output.FrameOutput;
	import cv.util.GeomUtil;
	import cv.util.MathUtil;
	import cv.util.ArrayUtil;
	import cv.util.ColorUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	[IconFile("icons/EmitterIcon.png")]
	[TagName("Emitter")]
	
	//--------------------------------------
    //  Events
    //--------------------------------------
	// None
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The Emitter class is the hub of particle system. It coordinates which output classes, 
	 * cavanses, and renders are used for it's particles. It also determines <strong>where</strong>
	 * the particles will be generated.
	 * 
	 * <p>This differs from the canvas slightly. The canvas determines where the particles can go after they 
	 * are created. Setting up the bounds that they can reach before they are handled by the edge filter. The
	 * emitter determines where the particles are created. This allows you to have particles created in a 100x100
	 * square but can go all over the stage.</p>
	 * 
     * @langversion 3.0
     * @playerversion Flash 9
     */
	public class Emitter extends Sprite {
		
		///////////////////////////////
		// Particle Initial Settings //
		///////////////////////////////
		
		/**
         * The lifespan of the particle in milliseconds. After that time is up, it is removed
		 * from display.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=5000, type=int)]
		public var lifeSpan:int = 5000; // In milliseconds
		
		/**
         * The mass of a particle. The larger, the harder it is to move.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=1)]
		public var mass:Number = 1;
		
		/**
         * The initial alpha of a particle. From 0 to 1.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=1)]
		public var opacity:Number = 1;
		
		/**
         * The minimum alpha in a range for the particle randomly initially. From 0 to 1.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable()]
		public var opacityMin:Number = 0;
		
		/**
         * The maximum alpha in a range for the particle randomly initially. From 0 to 1.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable()]
		public var opacityMax:Number = 0;
		
		/**
         * The initial X velocity of a particle.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=0)]
		public var velocityX:Number = 0;
		
		/**
         * The minimum X velocity in a range to move the particle randomly initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=-1)]
		public var velocityXMin:Number = -1;
		
		/**
         * The maximum X velocity in a range to move the particle randomly initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=1)]
		public var velocityXMax:Number = 1;
		
		/**
         * The initial Y velocity of a particle.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=0)]
		public var velocityY:Number = 0;
		
		/**
         * The minimum Y velocity in a range to move the particle randomly initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=-1)]
		public var velocityYMin:Number = -1;
		
		/**
         * The maximum Y velocity in a range to move the particle randomly initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=1)]
		public var velocityYMax:Number = 1;
		
		/**
         * The initial spinning velocity of a particle.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=0)]
		public var velocityRotate:Number = 0;
		
		/**
         * The minimum spin in a range to spin the particle randomly initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable()]
		public var velocityRotateMin:Number;
		
		/**
         * The maximum spin in a range to spin the particle randomly initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable()]
		public var velocityRotateMax:Number;
		
		/**
         * The direction the particle will move in. From 0 to 360.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(verbose=1)]
		public var velocityAngle:Number = 0;
		
		/**
         * The minimum angle in a range to move in a random direction. From 0 to 360.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(verbose=1)]
		public var velocityAngleMin:Number;
		
		/**
         * The maximum angle in a range to move in a random direction. From 0 to 360.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(verbose=1)]
		public var velocityAngleMax:Number;
		
		/**
         * The initial rotation of a particle. From 0 to 360.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable()]
		public var rotate:Number = 0;
		
		/**
         * The minimum rotation in a range to rotate the particle randomly initially. From 0 to 360.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(verbose=1)]
		public var rotateMin:Number;
		
		/**
         * The maximum rotation in a range to rotate the particle randomly initially. From 0 to 360.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(verbose=1)]
		public var rotateMax:Number;
		
		/**
         * The initial scale of a particle.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=1)]
		public var scale:Number = 1;
		
		/**
         * The minimum scale in a range to scale the particle randomly initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable()]
		public var scaleMin:Number;
		
		/**
         * The maximum scale in a range to scale the particle randomly initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable()]
		public var scaleMax:Number;
		
		/**
         * The initial tint of a particle.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		public var color:int = -1;
		
		/**
         * The minimum color in a range to tint the particle randomly initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		public var colorMin:int = -1;
		
		/**
         * The maximum color in a range to tint the particle randomly initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		public var colorMax:int = -1;
		
		/**
         * If a frame is randomly selected initially.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=false)]
		public var selectRandomFrame:Boolean = false;
		
		//////////////////////
		// Emitter Settings //
		//////////////////////
		
		/**
         * Gets or sets whether the emitter is active and running.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		[Inspectable(defaultValue=true)]
		public var enabled:Boolean = true;
		
		/**
		 * Gets or sets how many particles are emitted during each emit&#40;&#41; call.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 */
		public var numberOfParticles:uint = 1;
		
		/**
         * Gets or sets the output class used. The default is the <code>SteadyOutput()</code>.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		public var output:IOutput;
		
		/**
		 * Gets or sets pixel snapping when frame caching is enabled. Pixel snapping
		 * determines whether or not the Bitmap object is snapped to the nearest pixel.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 */
		public var pixelSnapping:String = PixelSnapping.AUTO;
		
		/**
         * Gets or sets the renderer used. The default is the <code>DisplayObjectRenderer()</code>.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		public var renderer:IRenderer;
		
		/**
		 * Gets or sets bitmap smoothing when using frame caching.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 */
		public var smoothing:Boolean = false;
		
		/**
		 * Gets or sets whether bitmap caching is enabled on particles used within this emitter. 
		 * If set to true, Flash Player or Adobe AIR caches an internal bitmap representation of 
		 * the display object. This caching can increase performance for display objects that 
		 * contain complex vector content.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 */
		[Inspectable(defaultValue=false)]
		public var useCacheAsBitmap:Boolean = false;
		
		/**
		 * Gets or sets whether frame caching will be enabled. Frame caching takes a snapshot
		 * of each frame of a movieclip and stores the bitmaps in an array. This bitmapdata is
		 * used later for new particles. This can greatly improve performance on occasion (especially
		 * movieclips with lots of fiters used inside or multiple frames).
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 */
		[Inspectable(defaultValue=false)]
		public var useFrameCaching:Boolean = false;
		
		/**
		 * Gets or sets the blend mode applied to particles when they are created.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 */
		public var particleBlendMode:String = BlendMode.NORMAL;
		
		//////////////
		// Internal //
		//////////////
		
		/** @private */
		protected var _cacheTarget:MovieClip;
		/** @private */
		protected var _canvas:Rectangle;
		/** @private */
		//protected static var _destroy:Dictionary = new Dictionary(true);
		/** @private */
		protected var _destroyEmitter:Emitter;
		/** @private */
		protected var _edgeFilter:IEdgeFilter;
		/** @private */
		protected var _emitter:Rectangle = new Rectangle();
		/** @private */
		protected var _filters:Array = new Array();
		/** @private */
		protected var _frameCache:Array;
		/** @private */
		protected var _particles:Array = new Array();
		/** @private */
		protected static var _recycleBin:Dictionary = new Dictionary();
		/** @private */
		protected var _spriteClass:Class;
		/** @private */
		protected var _target:DisplayObjectContainer;
		/** @private */
		//protected static var _update:Dictionary = new Dictionary(true);
		/** @private */
		protected var _updateEmitter:Emitter;
		/** @private */
		protected var isLivePreview:Boolean = false;
		
		public function Emitter(spriteClass:Class = null, useFrameCaching:Boolean = true) {
			isLivePreview = checkLivePreview();
			
			if (spriteClass) _spriteClass = spriteClass;
			this.useFrameCaching = useFrameCaching;
			_target = this;
			renderer = new DisplayObjectRenderer();
			output = new FrameOutput();
			this.addEventListener(Event.ADDED_TO_STAGE, stageHandler, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageHandler, false, 0, true);
			
			if (!isLivePreview) {
				setSize(super.width, super.height);
				this.x = super.x;
				this.y = super.y;
				
				super.x = 0;
				super.y = 0;
				super.scaleX = 1;
				super.scaleY = 1;
				if(numChildren > 0) removeChildAt(0);
				
				Orion.addEmitter(this);
				Orion.start();
			}
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * Gets the frame cache movieclip. This is the movieclip that has had
		 * it's frames cached.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Property
		 */
		public function get cacheTarget():MovieClip {
			return _cacheTarget;
		}
		
		/**
		 * Gets or sets the containining display object that will hold the
		 * particles.
		 * 
		 * @default The parent emitter.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Property
		 */
		public function get container():DisplayObjectContainer { return _target; }
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9
         */
		public function set container(value:DisplayObjectContainer):void {
			_target = value;
			updateCanvas();
			renderer.update(_target, _canvas);
		}
		
		/**
		 * Gets a reference to the emitter set for onDestroy
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Property
		 */
		public function get destroyEmitter():Emitter {
			return _destroyEmitter;
		}
		
		/**
		 * The storage location for frames that are cached. Used by filters and emitters.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Property
		 */
		public function get frameCache():Array {
			return _frameCache;
		}
		
		/**
		 * Gets the height of the emitter, setting is disabled.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Property
		 */
		override public function get height():Number { return _emitter.height; }
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9
         */
		override public function set height(value:Number):void {
			setSize(width, value);
		}
		
		/**
		 * Gets the current particle count for this emitter
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Property
		 */
		public function get particleCount():uint {
			return _particles.length;
		}
		
		/**
         * Gets or sets the specific library linkId (class reference)
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Property
		 */
		public function get spriteClass():Class {
			return _spriteClass;
		}
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9
         */
		public function set spriteClass(value:Class):void {
			_spriteClass = value;
			delete _recycleBin[this];
			_frameCache = null;
		}
		
		/**
         * Gets or sets the specific library linkId (class reference) as a String.
		 * This is used primarily for the component inspector since it can't
		 * be passed a Class reference.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Property
		 */
		public function get spriteClassString():String {
			return getQualifiedClassName(spriteClass);
		}
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9
         */
		[Inspectable(type=String)]
		public function set spriteClassString(value:String):void {
			spriteClass = getDefinitionByName(value) as Class;
		}
		
		/**
		 * Gets a reference to the emitter set for onUpdate
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Property
		 */
		public function get updateEmitter():Emitter {
			return _updateEmitter;
		}
		
		/**
		 * Gets the width of the emitter, setting is disabled.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Property
		 */
		override public function get width():Number { return _emitter.width; }
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9
         */
		override public function set width(value:Number):void {
			setSize(value, height);
		}
		
		/**
		 * Gets or sets the x coordinate of the interal point used.
		 * 
		 * @see #getCoordinate()
		 * @see #y
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Property
		 */
		override public function get x():Number {
			return isLivePreview ? super.x : _emitter.x;
		}
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9
         */
		override public function set x(value:Number):void {
			if (isLivePreview) {
				super.x = value;
			} else {
				_emitter.x = value;
			}
		}
		
		/**
		 * Gets or sets the y coordinate of the interal point used.
		 * 
		 * @see #getCoordinate()
		 * @see #x
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Property
		 */
		override public function get y():Number {
			return isLivePreview ? super.y : _emitter.y;
		}
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9
         */
		override public function set y(value:Number):void {
			if (isLivePreview) {
				super.y = value;
			} else {
				_emitter.y = value;
			}
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Adds a filter to apply it's settings to the particles of the emitter.
		 * 
		 * @param	filter<IFilter> The filter to be added.
		 * @return The reference to the filter just added.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function addFilter(filter:IFilter):IFilter {
			_filters.push(filter);
			return filter;
		}
		
		/**
		 * Causes the emitter to add particles.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function emit(point:Point = null):void {
			if(numberOfParticles > 1) {
				var i:int = numberOfParticles;
				while (i--) {
					addParticle(point);
				}
			} else {
				addParticle(point);
			}
		}
		
		/**
		 * Gets the canvas used internally by the Emitter
		 * 
		 * @return Returns a rectange of the canvas dimensions.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		public function getCanvas():Rectangle {
			return _canvas;
		}
		
		/**
		 * Gets the current edge fitler.
		 * 
		 * @return The current edge filter in use. If not set, will return null.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function getEdgeFilter():IEdgeFilter {
			return _edgeFilter;
		}
		
		/**
		 * Gets the filters being applied by the emitter.
		 * 
		 * @return Returns a dictionary of all the filters.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function getFilters():Array {
			return _filters;
		}
		
		/*public function addUpdateEmitter(emitter:Emitter):void {
			_update[emitter] = emitter;
			_update[emitter].output = null;
		}
		
		public function addDestroyEmitter(emitter:Emitter):void {
			_destroy[emitter] = emitter;
			_destroy[emitter].output = null;
		}*/
		
		/**
		 * Sets an update emitter. This is triggered everytime a particle from this emitter
		 * gets updated. This allows for effects like trailing smoke of a particle.
		 * 
		 * @param	emitter<Emitter> A seperate emitter to be used for updates.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function onUpdate(emitter:Emitter):void {
			_updateEmitter = emitter;
			_updateEmitter.output = null;
		}
		
		/**
		 * Sets an destroy emitter. This is triggered everytime a particle from this emitter
		 * is destroyed. This allows for effects like the explosion after a firework goes up.
		 * 
		 * @param	emitter<Emitter> A seperate emitter to be used on removal of particles.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function onDestroy(emitter:Emitter):void {
			_destroyEmitter = emitter;
			_destroyEmitter.output = null;
		}
		
		/**
		 * Gets all the particles in the emitter's system currently.
		 * 
		 * @return Returns a dictionary of all the particles.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		public function getParticles():Array {
			return _particles;
		}
		
		/**
		 * Removes all particles from the emitter.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		public function removeAllParticles():void {
			var i:int = _particles.length;
			while (i--) {
				removeParticle(this, _particles[i]);
			}
			_particles = new Array();
		}
		
		/**
		 * Removes a filter from the emitter. Pass in the reference to the filter
		 * that was added.
		 * 
		 * @param	filter
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function removeFilter(filter:IFilter = null):void {
			if (filter) {
				ArrayUtil.removeItem(_filters, filter);
			}
		}
		
		/**
		 * Updates all the particles and positions, updates the output and renderer
		 * class as well.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function renderAll():void {
			if(_spriteClass) {
				var i:int = _particles.length;
				while (i--) {
					render(_particles[i]);
				}
				
				// Dynamically call a static function from different classes
				if (output) output.reflect()["update"](output, this);
				renderer.render(this);
			}
		}
		
		/**
		 * Sets the edge filter used by the emitter to determine what the particles
		 * will do when they hit the edge. Pass nothing to it in order to reset it.
		 * 
		 * @param	filter<IEdgeFilter> The filter to be used.
		 * @default null
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function setEdgeFilter(filter:IEdgeFilter = null):void {
			if (!filter) {
				_edgeFilter = null;
				return;
			}
			
			_edgeFilter = filter;
		}
		
		/**
		 * Sets the renderer used by the emitter.
		 * 
		 * @param	renderer<IRenderer> The renderer to 
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function setRenderer(renderer:IRenderer):void {
			this.renderer = renderer;
			this.renderer.update(_target, _canvas);
		}
		
		/**
		 * Sets the dimensions of the Emitter, acts differently for each type of emitter.
		 * 
		 * @param	width<Number> The width of the emitter
		 * @param	height<Number> The height of the emitter
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function setSize(width:Number, height:Number):void { }
		
		/**
		 * Causes the canvas dimensions to be updated if positions have changed.
		 * This should only be necessary if the emitter is inside a container movieclip, 
		 * and the container has moved.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Method
		 */
		public function updateCanvas():void {
			_canvas = _target.stage.getBounds(_target);
			_canvas.width = _target.stage.stageWidth;
			_canvas.height = _target.stage.stageHeight;
			_canvas.x += _canvas.topLeft.x * -1;
			_canvas.y += _canvas.topLeft.y * -1;
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
		 * @param	pt<Point> The point to position the particle at.
		 * @default null (getCoordinate)
		 * 
		 * @param	c<Class> The class to be used for the particle.
		 * @default null (spriteClass)
		 * 
		 * @see #getCoordinate()
		 * @see #spriteClass
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		protected function addParticle(pt:Point = null):void {
			pt = pt || getCoordinate();
			if (pt) {
				var p:Particle = (_recycleBin[this] && _recycleBin[this].length > 0) ? getRecycled() : getNew();
				
				// Reset particle
				p.addEventListener(ParticleEvent.DESTROY, destroyHandler, false, 0, true);
				p.addEventListener(ParticleEvent.UPDATE,   updateHandler, false, 0, true);
				p.x = pt.x;
				p.y = pt.y;
				p.timeStamp = Orion.currentTime;
				p.mass = !isNaN(mass) ? mass : 1;
				
				if (colorMin >= 0 && colorMax > colorMin) {
					p.color = ColorUtil.interpolateColors(colorMin, colorMax, Math.random());
				} else {
					if (!isNaN(color)) {
						p.color = color;
					} else {
						p.color = 0xFFFFFF;
					}
				}
				
				if(opacityMin >= 0 && opacityMax > opacityMin) {
					p.alpha = MathUtil.randomRange(opacityMin, opacityMax);
				} else {
					p.alpha = opacity || 1;
				}
				
				if(!isNaN(velocityXMin) && velocityXMax > velocityXMin) {
					p.velocity.x = MathUtil.randomRange(velocityXMin, velocityXMax);
				} else {
					p.velocity.x = velocityX || 0;
				}
				
				if(!isNaN(velocityYMin) && velocityYMax > velocityYMin) {
					p.velocity.y = MathUtil.randomRange(velocityYMin, velocityYMax);
				} else {
					p.velocity.y = velocityY || 0;
				}
				
				if(!isNaN(velocityRotateMin) && velocityRotateMax > velocityRotateMin) {
					p.angularVelocity = MathUtil.randomRange(velocityRotateMin, velocityRotateMax);
				} else {
					p.angularVelocity = velocityRotate || 0;
				}
				
				var angle:Number;
				if (!isNaN(velocityAngleMin) && velocityAngleMax > velocityAngleMin) {
					angle = MathUtil.randomRange(velocityAngleMin, velocityAngleMax);
				} else {
					angle = velocityAngle || 0;
				}
				if (angle) {
					angle = MathUtil.degreesToRadians(angle);
					p.velocity = GeomUtil.rotateCoord(p.velocity.x, p.velocity.y, Math.sin(angle), Math.cos(angle), false);
				}
				
				if(!isNaN(scaleMin) && scaleMax > scaleMin) {
					p.scaleX = p.scaleY = MathUtil.randomRange(scaleMin, scaleMax);
				} else {
					if (!isNaN(scale)) {
						p.scaleX = p.scaleY = scale;
					} else {
						p.scaleX = p.scaleY = 1;
					}
				}
				
				if(!isNaN(rotateMin) && rotateMax > rotateMin) {
					p.rotation = MathUtil.randomRange(rotateMin, rotateMax);
				} else {
					p.rotation = rotate || 0;
				}
				
				if (selectRandomFrame) {
					if(useFrameCaching) {
						gotoAndStopCached(p, int(MathUtil.randomRange(0, (_cacheTarget.totalFrames - 1))));
					} else {
						var mc:MovieClip = p.target as MovieClip;
						mc.gotoAndStop(int(MathUtil.randomRange(1, mc.totalFrames)));
					}
				}
				
				renderer.addParticle(p, this);
				_particles.push(p);
			}
		}
		
		protected function gotoAndStopCached(p:Particle, frame:int):void {
			var bmp:Bitmap = Bitmap(Sprite(p.target).getChildAt(0));
			bmp.bitmapData = _frameCache[frame][0];
			bmp.x = _frameCache[frame][1];
			bmp.y = _frameCache[frame][2];
		}
		
		/**
		 * If it's a movieclip, cache it's frames.
		 * 
		 * @param	p<Particle> The particle to have it's frames cached.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		protected function cacheFrames(mc:MovieClip):void {
			_cacheTarget = mc;
			_frameCache = new Array();
			
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
				bmpData.draw(_cacheTarget, matrix, cTransform, particleBlendMode, null, smoothing);
				_frameCache.push([bmpData, bounds.left * 2, bounds.top * 2]);
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
		 * Determines if the emitter is on the Flash IDE or not.
		 * 
		 * @return Whether the emitter is in the IDE or not.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		protected function checkLivePreview():Boolean {
			if (parent == null) { return false; }
			var className:String;
			try {
				className = getQualifiedClassName(parent);	
			} catch (e:Error) {}
			return (className == "fl.livepreview::LivePreviewParent");	
		}
		
		/**
		 * Returns a coordinate it's designated position.
		 * 
		 * @return Returns a coordinate at the emitters x,y position.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		protected function getCoordinate():Point {
			return new Point(_emitter.x, _emitter.y);
		}
		
		/**
		 * Returns a new particle
		 * 
		 * @return	p<Particle> The particle
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		protected function getNew():Particle {
			var p:Particle;
			if (_frameCache && useFrameCaching) {
				// Init particle with reference of movieclip
				p = new Particle(_cacheTarget);
			} else {
				p = new Particle(new _spriteClass());
				if (p.target is MovieClip && useFrameCaching) {
					cacheFrames(p.target as MovieClip);
				}
			}
			
			if (useFrameCaching) {
				var bounds:Rectangle = _cacheTarget.getBounds(_cacheTarget);
				var arr:Array = _frameCache[0];
				var spr:Sprite = new Sprite();
				var bmp:Bitmap = new Bitmap(arr[0], pixelSnapping, smoothing);
				spr.addChild(bmp);
				bmp.x = arr[1];
				bmp.y = arr[2];
				p.target = spr;
			}
			
			p.target.blendMode = particleBlendMode;
			p.target.cacheAsBitmap = useCacheAsBitmap;
			return p;
		}
		
		/**
		 * Checks the recycle bin if a suitable particle can be re-used.
		 * 
		 * @return	p<Particle> The particle
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		protected function getRecycled():Particle {
			var p:Particle = _recycleBin[this].shift();
			p.active = true;
			p.currentFrame = 1;
			if (useFrameCaching) gotoAndStopCached(p, 0);
			return p;
		}
		
		/**
		 * Removes a particle from the renderer and stores the reference to the particle
		 * inside of the recyclebin dictionary.
		 * 
		 * @param	p<Particle> The particle to be recycled
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		protected function recycleParticle(p:Particle):void {
			removeParticle(this, p);
			
			if (!_recycleBin[this]) {
				_recycleBin[this] = new Array();
			}
			_recycleBin[this].push(p);
		}
		
		/**
		 * Removes a particle from the renderer. This is typically called during
		 * the garbage collection phase of a particle's life.
		 * 
		 * @param	e<Emitter> A reference to the emitter to remove from.
		 * @param	p<Particle> The particle to be removed.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		protected static function removeParticle(e:Emitter, p:Particle):void {
			p.active = false;
			p.dispatchEvent(new ParticleEvent(ParticleEvent.DESTROY, false, false, new Point(p.x, p.y), 1, p.velocity));
			p.removeEventListener(ParticleEvent.DESTROY, e.destroyHandler);
			p.removeEventListener(ParticleEvent.UPDATE, e.updateHandler);
			e.renderer.removeParticle(p);
			ArrayUtil.removeItem(e._particles, p);
		}
		
		/**
		 * Updates the specific particle based on the filters assigned to the emitter.
		 * Also handles any garbage clean up.
		 * 
		 * @param	p<Particle> The particle to be rendered and updated.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		protected function render(p:Particle):void {
			// Too small to see
			if (p.width < 1.5 || p.height < 1.5 || p.alpha < 0.02) {
				recycleParticle(p);
				return;
			}
			
			// Too old
			if ((Orion.currentTime - p.timeStamp) > lifeSpan) {
				if (lifeSpan >= 0) {
					recycleParticle(p);
					return;
				}
			}
			
			if (!p.active) return;
			
			// Apply Filters
			var i:int = _filters.length;
			if(i > 0) {
				while (i--) {
					_filters[i].applyFilter(p, this);
				}
			}
			
			if(p.velocity.x != 0) p.x += p.velocity.x;
			if(p.velocity.y != 0) p.y += p.velocity.y;
			if(p.angularVelocity != 0) p.rotation += p.angularVelocity;
			
			// React to edge
			if (_edgeFilter) _edgeFilter.applyFilter(p, _target, _canvas);
			
			// Eats up to 5fps at 1000 particles
			/* else {
				var b:Rectangle = p.target.getBounds(_target);
				if (b.right > _canvas.right || b.left < _canvas.left || b.bottom > _canvas.bottom || b.top < _canvas.top) {
					recycleParticle(p);
				}
			}*/
			
			p.dispatchEvent(new ParticleEvent(ParticleEvent.UPDATE, false, false, new Point(p.x, p.y), 1, p.velocity));
		}
		
		/**
		 * The stage handler, this listens for the Event.ADDED_TO_STAGE event,
		 * so it knows when it can access the stage property. If the emitter is
		 * not part of the display list, it will automatically disable itself.
		 * 
		 * @param	e<Event> The event dispatched.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		protected function stageHandler(e:Event):void {
			if (e.type == Event.ADDED_TO_STAGE) {
				enabled = true;
				updateCanvas();
				renderer.update(_target, _canvas);
			} else {
				enabled = false;
			}
		}
		
		/**
		 * The update handler, this listens for the update event
		 * of an individual particle. If an update emitter is
		 * set, it will emit once per update.
		 * 
		 * @param	e<ParticleEvent> The event dispatched.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		protected function updateHandler(e:ParticleEvent):void {
			if (_updateEmitter) _updateEmitter.emit(e.position);
			
			/*var d:Dictionary = _update, em:Emitter;
			for each (em in d) {
				em.addParticle(e.position);
			}*/
		}
		
		/**
		 * The destroy handler, this listens for the destroy event
		 * of an individual particle. If an destroy emitter is
		 * set, it will emit once upon the death of the particle.
		 * 
		 * @param	e<ParticleEvent> The event dispatched.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		protected function destroyHandler(e:ParticleEvent):void {
			if (_destroyEmitter) _destroyEmitter.emit(e.position);
			
			/*var d:Dictionary = _destroy, em:Emitter;
			for each (em in d) {
				em.addParticle(e.position);
			}*/
		}
	}
}