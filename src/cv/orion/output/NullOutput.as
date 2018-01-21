﻿/**
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
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The BurstOutput class adds the specified number of particles all at once, then
	 * doesn't add any new particles. This is useful if you want to just setup a system
	 * of say 10 particles and leave it a that.
	 * 
	 * @example There are two ways to control output. The first way it so set it
	 * in the constructor. The second way is to add it via the output property.
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.output.BurstOutput;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, new BurstOutput(40));
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.output = new BurstOutput(40);
	 * </listing>
	 */
	public class NullOutput implements IOutput {
		
		/**
		 * Controls the number of particles that are emitted.
		 */
		public function NullOutput() { }
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/** @copy cv.orion.interfaces.IOutput#paused **/
		public function get paused():Boolean { return true; }
		/** @private **/
		public function set paused(value:Boolean):void { }
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/** @copy cv.orion.interfaces.IOutput#pause() **/
		public function pause():void { }
		
		/** @copy cv.orion.interfaces.IOutput#play() **/
		public function play():void { }
		
		/** @copy cv.orion.interfaces.IOutput#update() **/
		public function getOutput(emitter:Orion):uint {	return 0; }
	}
}