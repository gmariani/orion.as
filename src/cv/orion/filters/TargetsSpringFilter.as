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
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The TargetsSpringFilter causes particles to spring to multiple targets. Depending
	 * on the strength of the spring, the particle might fling past the target, or
	 * get stuck bouncing back and forth.
	 * 
	 * @example There are two ways to apply the filter. The first way it so set it
	 * via the config object. The second way is to add it to the effectFilters array itself.
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.filters.TargetsSpringFilter;
	 * 
	 * var tgf:TargetsSpringFilter = new TargetsSpringFilter();
	 * tsf.addTarget(mc1, 0.025);
	 * tsf.addTarget(mc2, 0.05);
	 * tsf.addTarget(mc3, 0.025);
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {effectFilters:[tgf]});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.effectFilters.push(tgf);
	 * </listing>
	 */
	public class TargetsSpringFilter implements IFilter {
		
		/** @private */
		protected var _targets:Array = new Array();
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Adds a target for the particles to have a spring attraction to.
		 * 
		 * @param	target The target to be added.
		 * @param	springAmount How strong the spring attraction should be for the specific target.
		 * @default 0.05
		 * 
		 * @param   minDist The minimum distance the particle must be from the mouse
		 * 			for the filter to take effect.
		 * @default 100 Pixels
		 */
		public function addTarget(target:*, springAmount:Number = 0.05, minDist:Number = 100):void {
			_targets.push({ target:target, k:springAmount, minDist:minDist });
		}
		
		/**
		 * Removes a target from the spring system.
		 * 
		 * @param	target The target that was added previously.
		 */
		public function removeTarget(target:* = null):void {
			if (target) {
				Orion.removeItem(_targets, target);
			}
		}
		
		/**
		 * Removes all targets from the spring system, resetting it.
		 */
		public function clearTargets():void {
			_targets = new Array();
		}
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter() */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			var i:int = _targets.length, o:Object, oDist:Object;
			while (i--) {
				o = _targets[i];
				oDist = GeomUtil.getDistance(o.target.x, particle.target.x, o.target.y, particle.target.y);
				if (oDist.dist < o.minDist) {
					particle.velocity.x += (oDist.dx * o.k) / particle.mass;
					particle.velocity.y += (oDist.dy * o.k) / particle.mass;
				}
			}
		}
	}
}