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
	
	import cv.orion.interfaces.IOutput;
	import cv.orion.Orion;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The FunctionOutput class emits particles based on the given function. This allows
	 * you to pulse ouput of particles just by passing in a function that does that. Or
	 * if you wanted to create a sine output, create a function that handles that. This
	 * class is very flexible if used correctly.
	 * 
	 * @example There are two ways to control output. The first way it so set it
	 * in the constructor. The second way is to add it via the output property.
	 * 
	 * <p>To use the FunctionOutput class you must first create a function to be used 
	 * as a callback. In the following example, that is <code>pulse</code>.</p>
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.output.FunctionOutput;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, new FunctionOutput(pulse));
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.output = new FunctionOutput(pulse);
	 * 
	 * function pulse(startTime:uint, currentTime:uint):Boolean {
	 * 		var modT:uint = (currentTime - startTime) % 1000;
	 * 		if(modT < 500) return true;
	 * 		return false;
	 * }
	 * </listing>
	 */
	public class FunctionOutput implements IOutput {
		
		/**
		 * Function to check against
		 * 
		 * @private
		 */
		protected var f:Function;
		
		/**
		 * Start Time
		 * 
		 * @private
		 */
		protected var t:uint;
		/** @private */
		protected var _paused:Boolean = false;
		
		/**
		 * Controls how and when the particles are emitted via the callback function.
		 * 
		 * @param	callback<Function> The function used to determine when to emit particles.
		 */
		public function FunctionOutput(callback:Function) {
			f = callback;
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * Gets or sets the function used to control the output.
		 */
		public function get callback():Function { return f; }
		/** @private */
		public function set callback(value:Function):void {
			f = value;
		}
		
		/** @copy cv.orion.interfaces.IOutput#paused **/
		public function get paused():Boolean { return _paused; }
		/** @private **/
		public function set paused(value:Boolean):void {
			if (value == _paused) return;
			_paused = value;
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/** @copy cv.orion.interfaces.IOutput#pause() **/
		public function pause():void {
			this.paused = true;
		}
		
		/** @copy cv.orion.interfaces.IOutput#play() **/
		public function play():void {
			this.paused = false;
		}
		
		/** @copy cv.orion.interfaces.IOutput#update() **/
		public function update(emitter:Orion):void {
			if (!t) t = Orion.time;
			if (_paused) return;
			if (f(t, Orion.time)) {
				emitter.emit();
			}
		}
	}	
}