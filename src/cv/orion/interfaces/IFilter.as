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

package cv.orion.interfaces {
	
	import cv.Orion;
	import cv.orion.ParticleVO;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * Implement the IFilter interface to create a custom particle filter. 
	 * A particle filter applies a specific force or action to be applied
	 * to the particle.
	 * 
	 * <p>Such forces could be gravity, a spring motion, or even fading 
	 * the particle. The combination of these filters are strung
	 * together to form an effect.</p>
	 * 
	 * @see cv.Orion
	 */
	public interface IFilter {
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Applies the specified filter to a particular particle. 
		 * 
		 * @param	particle The individual particle.
		 * @param	target The emitter associated with the particle.
		 */
		function applyFilter(particle:ParticleVO, target:Orion):void;
	}
}