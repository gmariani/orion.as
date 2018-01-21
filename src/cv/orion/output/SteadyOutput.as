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
	 * The SteadyOutput class outputs particles at a predictable rate. This is useful if
	 * you just want particles to be outputted and don't care for anything fancy.
	 * 
	 * @example There are two ways to control output. The first way it so set it
	 * in the constructor. The second way is to add it via the output property.
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.output.SteadyOutput;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, new SteadyOutput(40));
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.output = new SteadyOutput(40);
	 * </listing> 
	 */
	public class SteadyOutput implements IOutput {
		
		/**
		 * The current rate assigned to SteadyOutput, in particles per second.
		 */
		public var particlesPerSecond:Number;
		
		/** @private **/
		protected var prevTime:Number;
		/** @private **/
		protected var difTime:Number;
		/** @private **/
		protected var dT:Number;
		/** @private */
		protected var _paused:Boolean = false;
		
		/**
		 * Controls the output of the particles of the emitter.
		 * 
		 * @param	particlesPerSecond<Number> The rate at which to output particles
		 * @default 20
		 */
		public function SteadyOutput(particlesPerSecond:Number = 20) {
			this.particlesPerSecond = particlesPerSecond;
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
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
		public function getOutput(emitter:Orion):uint {
			updateTimes(emitter);
			return checkEmit(emitter);
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		/**
		 * Updates the previous and difference in times.
		 * This determines when to emit and fix any pause
		 * issues.
		 * 
		 * @param	emitter
		 */
		protected function updateTimes(emitter:Orion):void {
			if (isNaN(prevTime)) prevTime = Orion.time;
			
			// Resume normally after being paused for a while
			if (!isNaN(difTime)) prevTime = Orion.time - difTime;
			
			// Add particles at the specificed rate
			dT = Orion.time - prevTime;
			difTime = emitter.paused ? dT : NaN;
		}
		
		/**
		 * Checks if it's time to emit particles and how many.
		 * 
		 * @param	emitter
		 */
		protected function checkEmit(emitter:Orion):uint {
			if (particlesPerSecond == 0) return 0;
			var pT:Number = 1000 / particlesPerSecond;
			if (dT >= pT) {
				prevTime = Orion.time;
				if (_paused) return 0;
				return dT / pT;
			} else {
				return 0;
			}
		}
	}
}