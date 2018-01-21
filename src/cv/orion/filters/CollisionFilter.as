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
	import cv.util.GeomUtil;
	import cv.util.MathUtil;
	import flash.geom.Point;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The CollisionFilter causes particles to bounce off each other if they hit.
	 * 
	 * @example There are two ways to apply the filter. The first way it so set it
	 * via the config object. The second way is to add it to the effectFilters array itself.
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.filters.CollisionFilter;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {effectFilters:[new CollisionFilter()]});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.effectFilters.push(new CollisionFilter());
	 * </listing>
	 */
	public class CollisionFilter implements IFilter {
		
		/** @private */
		protected const POINT:Point = new Point();
		/** @private */
		protected var vel0:Point;
		/** @private */
		protected var pos1:Point;
		/** @private */
		protected var vel1:Point;
		/** @private */
		protected var pos0:Point;
		/** @private */
		protected var angle:Number;
		/** @private */
		protected var sin:Number;
		/** @private */
		protected var cos:Number;
		/** @private */
		protected var oDist:Object;
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter() */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			var i:int = target.particles.length;
			var pRadius:Number = particle.target.width / 2;
			if (particle.target.height > particle.target.width) pRadius = particle.target.height / 2;
			while (i--) {
				var p2:ParticleVO = target.particles[i];
				
				// If it's the same particle, skip it
				if (p2 === particle) continue;
				
				oDist = GeomUtil.getDistance(p2.target.x, particle.target.x, p2.target.y, particle.target.y);
				
				var p2Radius:Number = p2.target.width / 2;
				if (p2.target.height > p2.target.width) p2Radius = p2.target.height / 2;
				
				if(oDist.dist < pRadius + p2Radius) {
					// calculate angle, sine and cosine
					angle = Math.atan2(oDist.dy, oDist.dx);
					sin = Math.sin(angle);
					cos = Math.cos(angle);
					
					// rotate particle's position
					pos0 = POINT;
					// rotate particle's velocity
					vel0 = GeomUtil.rotateCoord(particle.velocity.x, particle.velocity.y, sin, cos, true);
					
					// rotate p2's position
					pos1 = GeomUtil.rotateCoord(oDist.dx, oDist.dy, sin, cos, true);
					// rotate p2's velocity
					vel1 = GeomUtil.rotateCoord(p2.velocity.x, p2.velocity.y, sin, cos, true);
					
					if(particle.mass === p2.mass) {
						// swap the two velocities
						var temp:Point = vel0;
						vel0 = vel1;
						vel1 = temp;
					} else {
						// collision reaction
						var vxTotal:Number = vel0.x - vel1.x;
						vel0.x = ((particle.mass - p2.mass) * vel0.x + 2 * p2.mass * vel1.x) / (particle.mass + p2.mass);
						vel1.x = vxTotal + vel0.x;
					}
					
					// update position
					var absV:Number = MathUtil.abs(vel0.x) + MathUtil.abs(vel1.x);
					var overlap:Number = (pRadius + p2Radius) - MathUtil.abs(pos0.x - pos1.x);
					pos0.x += vel0.x / absV * overlap;
					pos1.x += vel1.x / absV * overlap;
					
					// rotate positions back
					pos0 = GeomUtil.rotateCoord(pos0.x, pos0.y, sin, cos, false);
					pos1 = GeomUtil.rotateCoord(pos1.x, pos1.y, sin, cos, false);
					
					// adjust positions to actual screen positions
					p2.target.x += pos1.x - oDist.dx;
					p2.target.y += pos1.y - oDist.dy;
					particle.target.x += pos0.x;
					particle.target.y += pos0.y;
					
					// rotate velocities back
					particle.velocity.fromPoint(GeomUtil.rotateCoord(vel0.x, vel0.y, sin, cos, false));
					p2.velocity.fromPoint(GeomUtil.rotateCoord(vel1.x, vel1.y, sin, cos, false));
				}
			}
		}
	}
}