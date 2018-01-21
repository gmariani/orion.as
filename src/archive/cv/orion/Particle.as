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

package cv.orion {

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The Particle class stores all the data pertaining to a given particle. This is used by
	 * the filters and emitters to handle all the animation.
     */
	public class Particle {
		
		/** @private **/
		protected static var _mass:Dictionary = new Dictionary(true);
		/** @private **/
		protected static var _angularVelocity:Dictionary = new Dictionary(true);
		/** @private **/
		protected static var _radius:Dictionary = new Dictionary(true);
		/** @private **/
		protected static var _currentFrame:Dictionary = new Dictionary(true);
		/** @private **/
		protected static var _active:Dictionary = new Dictionary(true);
		/** @private **/
		protected static var _timeStamp:Dictionary = new Dictionary(true);
		/** @private **/
		protected static var _target:Dictionary = new Dictionary(true);
		/** @private **/
		protected static var _velocity:Dictionary = new Dictionary(true);
		/** @private **/
		protected static var _color:Dictionary = new Dictionary(true);
		/** @private **/
		protected static var _colorTransform:Dictionary = new Dictionary(true);
		
		/**
		 * The actual particle being animated.
		 * 
		 * @param	displayObject<DisplayObject> The display object to be used as the particle.
		 */
		public function Particle(displayObject:DisplayObject) {
			this.target = displayObject;
			this.radius = this.target.width / 2;
			if (this.target.height > this.target.width) this.radius = this.target.height / 2;
			
			this.mass = 1;
			this.angularVelocity = 0;
			this.currentFrame = 1;
			this.active = true;
			this.timeStamp = 0;
			this.velocity = new Point();
			_color[this] = new Array(2);
			_color[this][0] = 0xFFFFFF;
			_color[this][1] = 0xFFFFFF;
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * Whether the particle is active and in use or not.
		 */
		public function get active():Boolean { return _active[this]; }
		/** @private **/
		public function set active(value:Boolean):void {
			_active[this] = value;
		}
		
		/**
		 * The spinning or angular velocity of the particle.
		 */
		public function get angularVelocity():Number { return _angularVelocity[this]; }
		/** @private **/
		public function set angularVelocity(value:Number):void {
			_angularVelocity[this] = value;
		}
		
		/**
		 * Gets or sets the color/tint of the particle. This is used int he ColorFilter as well.
		 */
		public function get color():Number { return _color[this][0]; }
		/** @private **/
		public function set color(value:Number):void {
			if(_color[this][0] != value) {
				_color[this][0] = value;
				target.transform.colorTransform = getColorTransform(this);
			}
		}
		
		/**
		 * The current frame of the target moveclip. Stored since it's been turned
		 * into a bitmap.
		 */
		public function get currentFrame():int { return _currentFrame[this]; }
		/** @private **/
		public function set currentFrame(value:int):void {
			_currentFrame[this] = value;
		}
		
		/**
		 * The mass of the particle. The higher the mass the harder it is for it to be moved.
		 */
		public function get mass():Number { return _mass[this]; }
		/** @private **/
		public function set mass(value:Number):void {
			_mass[this] = value;
		}
		
		/**
		 * The radius of the particle, used for the collision filter.
		 */
		public function get radius():Number { return _radius[this]; }
		/** @private **/
		public function set radius(value:Number):void {
			_radius[this] = value;
		}
		
		/**
		 * The actual DisplayObject used for display.
		 */
		public function get target():DisplayObject { return _target[this]; }
		/** @private **/
		public function set target(value:DisplayObject):void {
			_target[this] = value;
		}
		
		/**
		 * A time stamp of the particle, used to determine the lifespan of the particle.
		 */
		public function get timeStamp():Number { return _timeStamp[this]; }
		/** @private **/
		public function set timeStamp(value:Number):void {
			_timeStamp[this] = value;
		}
		
		/**
		 * The total velocity of the particle.
		 */
		public function get velocity():Point { return _velocity[this]; }
		/** @private **/
		public function set velocity(value:Point):void {
			_velocity[this] = value;
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Get a new color transform based on the set color.
		 * 
		 * @return Return a color transform based on the color.
		 */
		public static function getColorTransform(p:Particle):ColorTransform {
			if (!_colorTransform[p] || _color[p][1] != _color[p][0] ) {
				_colorTransform[p] = new ColorTransform(((_color[p][0] >>> 16) & 255) / 255, ((_color[p][0] >>> 8) & 255) / 255, (_color[p][0] & 255) / 255, 1, 0,0,0,0);
				//_colorTransform = new ColorTransform(((_color >>> 16) & 255) / 255, ((_color >>> 8) & 255) / 255, (_color & 255) / 255, ((_color >>> 24) & 255) / 255, 0,0,0,0);
			    _color[p][1] = _color[p][0];
			}
			return _colorTransform[p];
		}
	}
}