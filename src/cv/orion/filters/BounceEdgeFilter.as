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
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The BounceEdgeFilter forces a given particle to rebound off any edges it may
	 * encounter within the bounds of the emitter. 
	 * 
	 * @example There are two ways to apply the edge filter. The first way it so set it
	 * via the config object. The second way is to add it to the edgeFilter property itself.
	 * 
	 * <listing version="3.0">
	 * import cv.Orion;
	 * import cv.orion.filters.BounceEdgeFilter;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {edgeFilter:new BounceEdgeFilter(-0.5)});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.edgeFilter = new BounceEdgeFilter(-0.5);
	 * </listing>
	 */
	public class BounceEdgeFilter implements IFilter {
		
		/** @private */
		public var value:Number;
		/** @private */
		protected var r:Rectangle;
		/** @private */
		protected var d:DisplayObject;
		
		/**
		 * Applies the specified filter to a particular particle. 
		 * 
		 * @param	value<Number> The amount to multiply against the x and y velocity. 
		 * 			If negative, it will reverse motion (bounce).
		 * @default -0.5
		 */
		public function BounceEdgeFilter(value:Number = -0.5) {
			this.value = value;
		}
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter() */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			if (!target.canvas) return;
			
			d = particle.target;
			r = d.getBounds(target);
			
			if (r.right > target.canvas.right) {
				d.x -= r.right - target.canvas.right;
				particle.velocity.x *= value;
			} else if (r.left < target.canvas.left) {
				d.x += target.canvas.left - r.left;
				particle.velocity.x *= value;
			}
			
			if (r.bottom > target.canvas.bottom) {
				d.y -= r.bottom - target.canvas.bottom;
				particle.velocity.y *= value;
			} else if (r.top < target.canvas.top) {
				d.y += target.canvas.top - r.top;
				particle.velocity.y *= value;
			}
		}
	}
}