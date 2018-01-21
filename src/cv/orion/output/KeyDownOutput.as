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

package cv.orion.output {
	
	import cv.orion.Orion;
	import cv.orion.interfaces.IOutput;
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The KeyDownOutput class outputs particles if the specified key is pressed on the keyboard.
	 * It extends the SteadyOutput class, so the rate it outputs can also be adjusted.
	 * 
	 * @example There are two ways to control output. The first way it so set it
	 * in the constructor. The second way is to add it via the output property.
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.output.KeyDownOutput;
	 * import flash.ui.Keyboard;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, new KeyDownOutput(Keyboard.SPACE, this.stage, 40));
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.output = new KeyDownOutput(Keyboard.SPACE, this.stage, 40)
	 * </listing>
	 */
	public class KeyDownOutput extends SteadyOutput implements IOutput {
		
		/** @private */
		protected var _target:DisplayObject;
		/** @private */
		public var key:uint;
		/** @private */
		public var isDown:Boolean = false;
		
		/**
		 * Starts and stops outputting particles based on keyboard interaction.
		 * 
		 * @param	key Which key to listen for.
		 * 
		 * @param	target The target to attach the keyboard listener to.
		 * @default null
		 * 
		 * @param	particlesPerSecond The rate at which to output particles
		 * @default 20
		 */
		public function KeyDownOutput(key:uint, target:DisplayObject = null, particlesPerSecond:Number = 20) {
			super(particlesPerSecond);
			this.key = key;
			this.target = target;
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		/**
		 * Gets or sets the target to attach the keyboard listener to. As en example, you 
		 * could set this to the stage.
		 */
		public function get target():DisplayObject { return _target; }
		/** @private */
		public function set target(value:DisplayObject):void {
			if (_target) {
				target.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
				target.removeEventListener(KeyboardEvent.KEY_UP, keyHandler);
			}
			_target = value;
			
			if (_target) {
				target.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler, false, 0, true);
				target.addEventListener(KeyboardEvent.KEY_UP, keyHandler, false, 0, true);
			}
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/** @copy cv.orion.interfaces.IOutput#update() **/
		override public function update(emitter:Orion):void {
			if (!target && emitter.stage) target = emitter.stage;
			updateTimes(emitter);
			if (isDown) checkEmit(emitter);
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		/**
		 * Determines if they correct key is down or not.
		 * 
		 * @param	event
		 */
		protected function keyHandler(event:KeyboardEvent):void {
			var isHeld:Boolean = isDown;
			isDown = (key == event.keyCode && event.type == KeyboardEvent.KEY_DOWN);
			if(isDown && !isHeld) prevTime = NaN;
		}
	}
}