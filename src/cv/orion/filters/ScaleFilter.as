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

package cv.orion.filters {
	
	import cv.orion.Orion;
	import cv.orion.interfaces.IFilter;
	import cv.orion.ParticleVO;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The ScaleFilter causes particles to grow or shrink based on the given value.
	 * If the number is 1, it won't do anything. If the number is greater than 1, it will
	 * cause the particle to grow. If the number is less than 1, it will cause the particle
	 * to shrink.
	 * 
	 * @example There are two ways to apply the filter. The first way it so set it
	 * via the config object. The second way is to add it to the effectFilters array itself.
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.filters.ScaleFilter;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {effectFilters:[new ScaleFilter(1.1)]});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.effectFilters.push(new ScaleFilter(1.1));
	 * </listing> 
	 */
	public class ScaleFilter implements IFilter {
		
		/**
		 * The rate in which to scale the particle.
		 */
		public var value:Number;
		
		/**
		 * Causes particle to either shrink or grow depending on the given value.
		 * 
		 * @param	value The rate in which to scale the particle.
		 * @default 0.99
		 */
		public function ScaleFilter(value:Number = 0.99) {
			this.value = value;
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter() */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			particle.target.scaleX *= value;
			particle.target.scaleY *= value;
		}
	}
}