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
	 * The TimedOutput class outputs particles for a specified amount of time. It extends
	 * the SteadyOutput class, so the rate it outputs can also be adjusted.
	 * 
	 * @example There are two ways to control output. The first way it so set it
	 * in the constructor. The second way is to add it via the output property.
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.output.TimedOutput;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, new TimedOutput(1000, 40));
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.output = new TimedOutput(1000, 40);
	 * </listing>
	 */
	public class TimedOutput extends SteadyOutput implements IOutput {
		
		/**
		 * Gets or sets the duration that the particles are outputted.
		 */
		public var duration:uint;
		
		/** @private **/
		protected var t:Number;
		
		/**
		 * Controls the duration that the particles are emitted.
		 * 
		 * @param	duration<uint> How long the particles will be emitted, in milliseconds.
		 * @default 5000
		 * 
		 * @param	particlesPerSecond<Number> The rate at which to output particles
		 * @default 20
		 */
		public function TimedOutput(duration:uint = 5000, particlesPerSecond:Number = 20) {
			super(particlesPerSecond);
			this.duration = duration;
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * After the timer has stopped, you can start the timer again by
		 * resetting it with this method.
		 */
		public function reset():void {
			t = NaN;
			prevTime = NaN;
		}
		
		/** @copy cv.orion.interfaces.IOutput#update() **/
		override public function update(emitter:Orion):void {
			if (isNaN(t)) t = Orion.time;
			if ((Orion.time - t) <= duration) super.update(emitter);
		}
	}
}