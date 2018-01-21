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

package cv {
	
	import cv.orion.emitters.Emitter;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	//--------------------------------------
    //  Events
    //--------------------------------------
	// None
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * Orion is a particle system on par with Pulse or FLINT. Capable of handling gravity, repelling, 
	 * Brownian motion, and many other effects. Orion was also built with speed and size in mind. It has
	 * been tested up to 1500 particles animating near 40fps.
	 * 
     * @langversion 3.0
     * @playerversion Flash 9
     */
	// TODO: Add filters and effects to help xml
	// TODO: Make DisplayObjectEmitter component
	// TODO: Make DisplayObjectEmitter icon
	public class Orion {
		
		/**
		 * The current version of Orion.
		 */
		public static const VERSION:String = "1.0.0";
		
		private static var _active:Boolean = false;
		private static var _all:Array = new Array(); //Holds references to all our tween targets.
		private static var _sprite:Sprite = new Sprite(); //A reference to the sprite that we use to drive all our ENTER_FRAME events.
		private static var _instance:Orion = new Orion();
		private static var _pC:uint = 0; // Particle Count
		private static var _t:uint; // Current Time
		private static var _pt:uint; // Previous Time
		
		/**
		 * Instantiates Orion, but should never be accessed directly. It's
		 * automatically instantiated by importing.
		 * 
		 * @throws Throws an error if tried to access directly.
		 */
		public function Orion() {
			if(_instance) throw new Error("Only one instance of Orion is allowed.");
			_pt = _t = getTimer();
			_sprite.addEventListener(Event.ENTER_FRAME, renderAll, false, 0, true);
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * Returns the total number of particles in the system.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Property
		 */
		public static function get particleCount():uint {
			return _pC;
		}
		
		/**
		 * The current time used by Orion.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Property
		 */
		public static function get currentTime():uint {
			return _t;
		}
		
		/**
		 * The time from the last cycle.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Property
		 */
		public static function get previousTime():uint {
			return _pt;
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Add an emitter to the particle system.
		 * 
		 * @param	emitter<Emitter> The emitter to be added.
		 * @return The emitter that was added.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		public static function addEmitter(emitter:Emitter):Emitter {
			_all.push(emitter);
			return emitter;
		}
		
		/**
		 * Remove all particles from all emitters in the system.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		public static function removeAllParticles():void {
			var i:int = _all.length;
			while (i--) {
				_all[i].removeAllParticles();
			}
		}
		
		/**
		 * Remove an emitter from the particle system.
		 * 
		 * @param	emitter<Emitter> The emitter to be removed.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		public static function removeEmitter(emitter:Emitter = null):void {
			if (emitter) {
				var i:int = _all.length;
				while (i--) {
					var e:Emitter = _all[i];
					if (e == emitter) {
						e.enabled = false;
						e.removeAllParticles();
						_all.splice(i, 1);
						break;
					}
				}
			}
		}
		
		/**
		 * Starts up all emitters that are enabled.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		public static function start():void {
			_pt = _t = getTimer();
			_active = true;
		}
		
		/**
		 * Stops all emitters and animation.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		public static function stop():void {
			_active = false;
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		private static function renderAll(evt:Event = null):void {
			_pC = 0;
			if (_active) {
				var i:int = _all.length; 
				while (i--) {
					var e:Emitter = _all[i];
					if (e.enabled) {
						e.renderAll();
						_pC += e.particleCount;
					}
				}
			}
			
			_pt = _t;
			_t = getTimer();
		}
	}
}