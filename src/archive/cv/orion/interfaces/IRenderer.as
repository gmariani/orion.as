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
	import flash.events.Event;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * Implement the IRenderer interface to create a custom renderer. A renderer determines
	 * <strong>how</strong> a particle is drawn within flash. Normally items are drawn in Flash
	 * throught he native display system. This means, when you move a display object from x:20 
	 * to x:40, the screen is redrawn to reflect the change.
	 * 
	 * <p>By having a seperate rendering system, this allows you to have all the particles drawn 
	 * as a bitmap or even as pixels on a bitmap. This opens up a number of new effects that can 
	 * be created.</p>
	 */
	public interface IRenderer {
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Clears the renderer.
		 */
		function clear():void;
		
		/**
		 * Calls the renderer to draw the particles.
		 * 
		 * @param	emitter The emitter associated with the particles.
		 */
		function render(e:Event = null):void;
	}
}