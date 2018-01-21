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
	//import cv.util.MathUtil;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The DragFilter determines how easily a particle moves around. The lower the number
	 * the easier it can move, the higher the number, the slower it moves.
	 * 
	 * @example There are two ways to apply the filter. The first way it so set it
	 * via the config object. The second way is to add it to the effectFilters array itself.
	 * 
	 * <listing version="3.0">
	 * import cv.Orion;
	 * import cv.orion.filters.DragFilter;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {effectFilters:[new DragFilter(0.7)]});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.effectFilters.push(new DragFilter(0.7));
	 * </listing>
	 * 
	 * @internal 
	 * If on a flat surface
	 * F = Force of Friciton
	 * u = Coefficient of Friction
	 * N = Normal Force = mg
	 * 	m = Mass
	 * 	g = Gravity
	 * F = uN = umg = (0.3)(1,000kg)(9.8 meters per second2) = 2,940N
	 * 
	 * If on an incline
	 * N = mg cos{theta}
	 * F = mg sin{theta} + uN
	 * 
	 * We can take mass into account but we can't really take gravity becuase
	 * this class can't find out what that value is. So in lieu of normal force
	 * (N) we're going to use the current force... yes I know, it's wrong
	 * but it should look fine for the purposes of Orion.
	 * This is really a fake version of friction which simulates it well enough.
	 */
	public class DragFilter implements IFilter {
		
		/**
		 * The friction to be applied
		 */
		public var friction:Number;
		
		/**
		 * Controls how easily a particle moves around.
		 * 
		 * @param	friction The friction used to determine drag.
		 * @default 0.3
		 */
		public function DragFilter(friction:Number = 0.3) {
			this.friction = friction;
		}
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter() */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			// Right way
			/*var o:Object = MathUtil.getDistance(particle.velocity.x, particle.velocity.x, particle.velocity.y, particle.velocity.y);
			var speed:Number = o.dist;
			var angle:Number = MathUtil.getAngle(particle.velocity.x, particle.velocity.y);
			if (speed > friction) {
				speed -= friction;
			} else {
				speed = 0;
			}
			
			particle.velocity.x = Math.cos(angle) * speed;
			particle.velocity.y = Math.sin(angle) * speed;*/
			
			// Easy way
			particle.velocity.x *= friction;
			particle.velocity.y *= friction;
			particle.angularVelocity *= friction;
		}
	}
}