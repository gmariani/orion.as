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
	
	import cv.orion.interfaces.IFilter;
	import cv.orion.ParticleVO;
	import cv.Orion;
	import flash.geom.ColorTransform;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The ColorFilter transitions a particle's tint/color to the target color. This filter
	 * is useful for effects such as the FireworkEffect, where a particle goes from yellow
	 * to red.
	 * 
	 * @example There are two ways to apply the filter. The first way it so set it
	 * via the config object. The second way is to add it to the effectFilters array itself.
	 * 
	 * <listing version="3.0">
	 * import cv.Orion;
	 * import cv.orion.filters.ColorFilter;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {effectFilters:[new ColorFilter(0xCC3300)]});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.effectFilters.push(new ColorFilter(0xCC3300));
	 * </listing>
	 */
	public class ColorFilter implements IFilter {
		
		/** @private **/
		protected var _clr:ColorTransform = new ColorTransform();
		
		/**
		 * Tweens the tint/color of the particle to the target color specified.
		 * 
		 * @param	color The target color to match.
		 * @default 0xFFFFFF
		 */
		public function ColorFilter(color:uint = 0xFFFFFF) {
			this.color = color;
		}
		
		/**
		 * The target color to match.
		 */
		public function get color():uint { return _clr.color; }
		/** @private **/
		public function set color(value:uint):void { _clr.color = value; }
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter() */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			// Maintain alpha
			_clr.alphaMultiplier = particle.target.alpha;
			// Interpolate
			particle.target.transform.colorTransform = Orion.interpolateTransform(particle.target.transform.colorTransform, _clr, (Orion.time - particle.timeStamp) / target.settings.lifeSpan);
		}
	}
}