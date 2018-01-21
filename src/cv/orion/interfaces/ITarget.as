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
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * Implement the IOutput interface to create a custom output class. An output class 
	 * controls how fast and how many particles are emitted from the emitter. The default
	 * is SteadyOutput with the default rating.
	 * 
	 * <p>Output classes can vary in capabilities, but ultimately choose the one that suites
	 * your needs. More often than not, the SteadyOutput will accomplish your goals.</p>
	 */
	public interface ITarget {
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * This is called everytime the particles are called to update and be redrawn. Depending
		 * on the output class, this can determine the output of the particles.
		 * 
		 * @param	emitter The emitter to be used.
		 */
		function getCoordinate():Point;
	}
}