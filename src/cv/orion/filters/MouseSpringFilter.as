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
	import cv.util.GeomUtil;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The MouseSpringFilter causes particles to move toward the mouse in a spring motion.
	 * If the particle is going too fast when it hits the mouse, it will zoom past it til
	 * it slows down enough to head back towards the mouse. It will do this til it finally
	 * stops moving.
	 * 
	 * @example There are two ways to apply the filter. The first way it so set it
	 * via the config object. The second way is to add it to the effectFilters array itself.
	 * 
	 * <listing version="3.0">
	 * import cv.Orion;
	 * import cv.orion.filters.MouseSpringFilter;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {effectFilters:[new MouseSpringFilter(0.01)]});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.effectFilters.push(new MouseSpringFilter(0.01));
	 * </listing> 
	 */
	public class MouseSpringFilter implements IFilter {
		
		/**
		 * The strength of the spring used in the motion.
		 */
		public var springStrength:Number;
		
		/**
		 * The minimum distance the particle must be from the mouse for the filter to take effect.
		 */
		public var minDist:Number;
		
		/** @private */
		protected var oDist:Object;
		
		/**
		 * Causes particles to be attracted to the mouse and move with a spring motion.
		 * 
		 * @param	springStrength The strength of the spring used in the motion.
		 * @default 0.05
		 * 
		 * @param minDist The minimum distance the particle must be from the mouse
		 * 			for the filter to take effect.
		 * @default 100 Pixels
		 */
		public function MouseSpringFilter(springStrength:Number = 0.05, minDist:Number = 100) {
			this.springStrength = springStrength;
			this.minDist = minDist;
		}
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter() */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			oDist = GeomUtil.getDistance(target.mouseX, particle.target.x, target.mouseY, particle.target.y);
			if (oDist.dist < minDist) {
				particle.velocity.x += (oDist.dx * springStrength) / particle.mass;
				particle.velocity.y += (oDist.dy * springStrength) / particle.mass;
			}
		}
	}
}