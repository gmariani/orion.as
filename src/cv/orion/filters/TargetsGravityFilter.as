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
	import flash.geom.Point;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The TargetsGravityFilter causes particles to attract to multiple targets. The
	 * targets added won't be moved by Orion, so when a particle hits, it will bounce
	 * off of them without pushing the target away.
	 * 
	 * <p>Using the TargetsGravityFilter, you could easily setup a plantery system
	 * and actually have planets orbit around each other.</p>
	 * 
	 * @example There are two ways to apply the filter. The first way it so set it
	 * via the config object. The second way is to add it to the effectFilters array itself.
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.filters.TargetsGravityFilter;
	 * 
	 * var tgf:TargetsGravityFilter = new TargetsGravityFilter();
	 * tgf.addTarget(mc1, 1000, 20);
	 * tgf.addTarget(mc2, 2000, 30);
	 * tgf.addTarget(mc3, 4000, 40);
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {effectFilters:[tgf]});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.effectFilters.push(tgf);
	 * </listing>
	 */
	public class TargetsGravityFilter implements IFilter {
		
		/** @private */
		protected var _targets:Array = new Array();
		/** @private */
		protected var oDist:Object;
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Adds a target for the particles to have a gravity attraction to.
		 * 
		 * @param	target The target to be added.
		 * 
		 * @param	mass The mass given to the target. The higher the number, the stronger
		 * 			the gravitational force is.
		 * @default 1000
		 * 
		 * @param	radius The radius of the target.
		 * @default 0
		 */
		public function addTarget(target:*, mass:Number = 1000, radius:Number = 0):void {
			_targets.push({ target:target, m:mass, radius:radius });
		}
		
		/**
		 * Removes a target from the gravity system.
		 * 
		 * @param	target The target that was added previously.
		 */
		public function removeTarget(target:* = null):void {
			if (target) {
				Orion.removeItem(_targets, target);
			}
		}
		
		/**
		 * Removes all targets from the gravity system, resetting it.
		 */
		public function clearTargets():void {
			_targets = new Array();
		}
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter() */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			var i:int = _targets.length; 
			
			while (i--) {
				if (particle.mass == 0) continue;
				
				var o:Object = _targets[i];
				checkCollision(o, particle);
				
				// Calculate again since particles may have been repositioned
				oDist = GeomUtil.getDistance(o.target.x, particle.target.x, o.target.y, particle.target.y);
				var F:Number = particle.mass * o.m / oDist.distSQ;
				var ax:Number = F * oDist.dx / oDist.dist;
				var ay:Number = F * oDist.dy / oDist.dist;
				particle.velocity.x += ax / particle.mass;
				particle.velocity.y += ay / particle.mass;
			}
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		/** @private */
		protected function checkCollision(o:Object, p:ParticleVO):void {
			oDist = GeomUtil.getDistance(o.target.x, p.target.x, o.target.y, p.target.y);
			var pRadius:Number = p.target.width / 2;
			if (p.target.height > p.target.width) pRadius = p.target.height / 2;
			if(oDist.dist < pRadius + o.radius) {
				// calculate angle, sine and cosine
				var angle:Number = Math.atan2(oDist.dy, oDist.dx);
				var sin:Number = Math.sin(angle);
				var cos:Number = Math.cos(angle);
				
				// rotate particle's position
				var pos0:Point = new Point(0, 0);
				
				// rotate targets's position
				var pos1:Point = GeomUtil.rotateCoord(oDist.dx, oDist.dy, sin, cos, true);
				
				// rotate particle's velocity
				var vel0:Point = GeomUtil.rotateCoord(p.velocity.x, p.velocity.y, sin, cos, true);
				
				// rotate targets's velocity
				var vel1:Point = GeomUtil.rotateCoord(0, 0, sin, cos, true);
				
				// collision reaction
				var vxTotal:Number = vel0.x - vel1.x;
				vel0.x = ((p.mass - o.m) * vel0.x + 2 * o.m * vel1.x) / (p.mass + o.m);
				vel1.x = vxTotal + vel0.x;
				
				// update position
				var absV:Number = abs(vel0.x) + abs(vel1.x);
				var overlap:Number = (pRadius + o.radius) - abs(pos0.x - pos1.x);
				pos0.x += vel0.x / absV * overlap;
				
				// rotate positions back
				pos0 = GeomUtil.rotateCoord(pos0.x, pos0.y, sin, cos, false);
				
				// adjust positions to actual screen positions
				p.target.x += pos0.x;
				p.target.y += pos0.y;
				
				// rotate velocities back
				p.velocity.fromPoint(GeomUtil.rotateCoord(vel0.x, vel0.y, sin, cos, false));
			}
		}
		
		protected function abs(value:Number):Number {
			if (value < 0) value = -value;
			return value;
		}
	}
}