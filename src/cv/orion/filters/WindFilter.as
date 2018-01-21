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
	
	import cv.Orion;
	import cv.orion.interfaces.IFilter;
	import cv.orion.ParticleVO;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The WindFilter causes particles to be swept to a side at a given rate. Much
	 * like horizontal gravity.
	 * 
	 * @example There are two ways to apply the filter. The first way it so set it
	 * via the config object. The second way is to add it to the effectFilters array itself.
	 * 
	 * <listing version="3.0">
	 * import cv.Orion;
	 * import cv.orion.filters.WindFilter;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {effectFilters:[new WindFilter(2)]});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.effectFilters.push(new WindFilter(2));
	 * </listing> 
	 */
	public class WindFilter implements IFilter {
		
		/**
		 * The current rate affeecting th X axis.
		 */
		public var value:Number;
		
		/**
		 * Causes particles to be attracted to the floor.
		 * 
		 * @param	value The velocity added to the X axis. The higher the number, the stronger
		 * 			the wind is. Use negatives to push particles left, positive numbers to push right.
		 * @default 0.3
		 */
		public function WindFilter(value:Number = 0.3) {
			this.value = value;
		}
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter() */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			if (particle.mass == 0) return;
			particle.target.x += value / particle.mass;
		}
	}
}