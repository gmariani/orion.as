/**
* Orion ©2009 Gabriel Mariani. February 6th, 2009
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
	
	import cv.Orion;
	import cv.orion.interfaces.IOutput;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * OrionMouse emits particles from the mouse. Useful for effects like a mouse trailer.
     */
	public class OrionMouse extends Orion {
		
		/** @private **/
		private var _leaveEnabled:Boolean    = true;
		/** @private **/
		private var _mouseEnabled:Boolean    = false;
		/** @private **/
		private var _onlyOnMouseMove:Boolean = true;
		
		/** @copy cv.Orion#Orion() */
		public function OrionMouse(spriteClass:Class = null, output:IOutput = null, config:Object = null, useFrameCaching:Boolean = false) {
			super(spriteClass, output, config, useFrameCaching);
		}
		
		/**
		 * Causes the trailer to only emit particles when the user moves their mouse.
		 * 
		 * @default true
		 */
		public function get onlyOnMouseMove():Boolean {
			return _onlyOnMouseMove;
		}
		/** @private */
		public function set onlyOnMouseMove(value:Boolean):void {
			_onlyOnMouseMove = value;
			if (!_onlyOnMouseMove) _mouseEnabled = true;
		}
		
		/** @copy cv.Orion#emit() */
		override public function emit(point:Point = null):void {
			if (_leaveEnabled && _mouseEnabled) super.emit(point);
			if (_onlyOnMouseMove) _mouseEnabled = false;
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		/** @copy cv.Orion#getCoordinate() */
		override protected function getCoordinate():Point {
			_coordPoint.x = this.mouseX;
			_coordPoint.y = this.mouseY;
			return _coordPoint;
		}
		
		/**
		 * The mouse move handler, this listens for the MouseEvent.MOUSE_MOVE event,
		 * so it knows when to enable or disable the trailer. It also listens for
		 * the Event.MOUSE_LEAVE, to enable/disable when the mosue is off the stage.
		 * 
		 * @param	event<MouseEvent> The event dispatched.
		 */
		protected function leaveHandler(event:Event):void {
			_leaveEnabled = !(event.type == Event.MOUSE_LEAVE);
			if (_onlyOnMouseMove) _mouseEnabled = true;
		}
		
		/** @copy cv.Orionr#stageHandler()  */
		override protected function stageHandler(e:Event):void {
			if (e.type == Event.ADDED_TO_STAGE) {
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, leaveHandler, false, 0, true);
				this.stage.addEventListener(Event.MOUSE_LEAVE, leaveHandler, false, 0, true);
			} else {
				paused = true;
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, leaveHandler);
				this.stage.removeEventListener(Event.MOUSE_LEAVE, leaveHandler);
			}
		}
	}
}