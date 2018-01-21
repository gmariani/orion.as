package cv.orion.targets {
	
	import cv.orion.interfaces.ITarget;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MouseTarget implements ITarget {
		
		/** @private **/
		protected var _leaveEnabled:Boolean = true;
		/** @private **/
		protected var _mouseEnabled:Boolean = false;
		/** @private **/
		protected var _onlyOnMouseMove:Boolean = true;
		/** @private */
		protected var _stageRef:Stage;
		/** @private */
		protected const _pt:Point = new Point();
		
		public function MouseTarget(stageRef:Stage = null, onlyOnMouseMove:Boolean = true) {
			if (stageRef) addStageListeners(stageRef);
			this.onlyOnMouseMove = true;
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
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		public function addStageListeners(stageRef:Stage):void {
			if (_stageRef) removeStageListeners();
			_stageRef = stageRef;
			_stageRef.addEventListener(MouseEvent.MOUSE_MOVE, leaveHandler, false, 0, true);
			_stageRef.addEventListener(Event.MOUSE_LEAVE, 	  leaveHandler, false, 0, true);
		}
		
		public function getCoordinate():Point {
			var emit:Boolean = false;
			if (_leaveEnabled && _mouseEnabled) {
				emit = true;
				_pt.x = stageRef.mouseX;
				_pt.y = stageRef.mouseY;
			}
			if (_onlyOnMouseMove) _mouseEnabled = false;
			return emit ? _pt : null;
		}
		
		public function removeStageListeners():void {
			_stageRef.removeEventListener(MouseEvent.MOUSE_MOVE, leaveHandler);
			_stageRef.removeEventListener(Event.MOUSE_LEAVE, 	 leaveHandler);
			_stageRef = null;
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
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
	}
}