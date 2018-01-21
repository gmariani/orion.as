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
	
	import cv.orion.emitters.Emitter;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[IconFile("icons/MouseEmitterIcon.png")]
	[TagName("Mouse Emitter")]
	
	//--------------------------------------
    //  Events
    //--------------------------------------
	// None
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The MouseEmitter class emits particles from the mouse. Useful for effects
	 * like a mouse trailer.
	 * 
     * @langversion 3.0
     * @playerversion Flash 9
     */
	public class MouseEmitter extends Emitter {
		
		private var _leaveEnabled:Boolean = true;
		private var _mouseEnabled:Boolean = false;
		private var _onlyOnMouseMove:Boolean = true;
		
		public function MouseEmitter(spriteClass:Class = null, useFrameCaching:Boolean = true) {
			super(spriteClass, useFrameCaching);
		}
		
		/**
		 * Causes the trailer to only emit particles when the user moves their mouse.
		 * 
		 * @default true
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Property
		 */
		public function get onlyOnMouseMove():Boolean {
			return _onlyOnMouseMove;
		}
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9
         */
		[Inspectable(defaultValue=true)]
		public function set onlyOnMouseMove(value:Boolean):void {
			_onlyOnMouseMove = value;
			if (!_onlyOnMouseMove) _mouseEnabled = true;
		}
		
		override public function emit(point:Point = null):void {
			if(_leaveEnabled && _mouseEnabled) {
				super.emit(point);
			}
			
			if (_onlyOnMouseMove) _mouseEnabled = false;
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		/**
		 * Returns the current mouse coordinates.
		 * 
		 * @return Returns the mouse x and y coordiantes.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		override protected function getCoordinate():Point {
			return new Point(this.mouseX, this.mouseY);
		}
		
		/**
		 * The mouse move handler, this listens for the MouseEvent.MOUSE_MOVE event,
		 * so it knows when to enable or disable the trailer. It also listens for
		 * the Event.MOUSE_LEAVE, to enable/disable when the mosue is off the stage.
		 * 
		 * @param	event<MouseEvent> The event dispatched.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		protected function leaveHandler(event:Event):void {
			_leaveEnabled = !(event.type == Event.MOUSE_LEAVE);
			if (_onlyOnMouseMove) _mouseEnabled = true;
		}
		
		/**
		 * The stage handler, this listens foro the Event.ADDED_TO_STAGE event,
		 * so it knows when it can access the stage property. If the emitter is
		 * not part of the display list, it will automatically disable itself.
		 * 
		 * @param	e<Event> The event dispatched.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		override protected function stageHandler(e:Event):void {
			if (e.type == Event.ADDED_TO_STAGE) {
				enabled = true;
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, leaveHandler, false, 0, true);
				this.stage.addEventListener(Event.MOUSE_LEAVE, leaveHandler, false, 0, true);
				updateCanvas();
				renderer.update(_target, _canvas);
			} else {
				enabled = false;
			}
		}
	}
}