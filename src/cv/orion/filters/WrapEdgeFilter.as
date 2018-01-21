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
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The WrapEdgeFilter makes a particle 'wrap', and appear at the opposite edge once it's
	 * hit the edge of the canvas.
	 * 
	 * @example There are two ways to apply the edge filter. The first way it so set it
	 * via the config object. The second way is to add it to the edgeFilter property itself.
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.filters.WrapEdgeFilter;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {edgeFilter:new WrapEdgeFilter()});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.edgeFilter = new WrapEdgeFilter();
	 * </listing>
	 */
	public class WrapEdgeFilter implements IFilter {
		
		/** @private */
		protected var r:Rectangle;
		/** @private */
		protected var dx:uint;
		/** @private */
		protected var dy:uint;
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter()  */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			if (!target.canvas) return;
			
			var d:DisplayObject = particle.target;
			r = d.getBounds(target);
			dx = uint(d.x - r.topLeft.x);
			dy = uint(d.y - r.topLeft.y);
			if (r.left > target.canvas.right) {
				d.x = target.canvas.left - dx;
			} else if (r.right < target.canvas.left) {
				d.x = target.canvas.right + dx;
			}
			if(r.top > target.canvas.bottom) {
				d.y = target.canvas.top - dy;
			} else if (r.bottom < target.canvas.top) {
				d.y = target.canvas.bottom + dy;
			}
		}
	}
}