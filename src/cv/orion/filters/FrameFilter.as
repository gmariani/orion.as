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
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The FrameFilter will progress a particles current frame by one each time the particle
	 * is updated.
	 * 
	 * @example There are two ways to apply the filter. The first way it so set it
	 * via the config object. The second way is to add it to the effectFilters array itself.
	 * 
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.filters.FrameFilter;
	 * 
	 * // First method
	 * var e:Orion = new Orion(linkageClass, null, {effectFilters:[new FrameFilter()]});
	 * 
	 * // Second method
	 * var e2:Orion = new Orion(linkageClass);
	 * e2.effectFilters.push(new FrameFilter());
	 * </listing> 
	 */
	public class FrameFilter implements IFilter {
		
		/**
		 * If the filter is set to loop
		 */
		public var loop:Boolean;
		
		/**
		 * Causes the particle to go through the frames, with the option of looping.
		 * 
		 * @param	loop Whether to loop the movieclip or not
		 * @default false
		 */
		public function FrameFilter(loop:Boolean = false) {
			this.loop = loop;
		}
		
		/** @copy cv.orion.interfaces.IFilter#applyFilter() */
		public function applyFilter(particle:ParticleVO, target:Orion):void {
			if (target.useFrameCaching) {
				if(target.cacheTarget.totalFrames > 1) {
					if (particle.currentFrame != target.cacheTarget.totalFrames) {
						particle.currentFrame++;
					} else if (loop) {
						particle.currentFrame = 1;
					} else {
						particle.target.alpha = 0;
					}
					
					var bmp:Bitmap = Bitmap(Sprite(particle.target).getChildAt(0));
					var arr:Array = target.cacheFrames[(particle.currentFrame - 1)];
					if (arr) {
						bmp.bitmapData = arr[0];
						bmp.x = arr[1];
						bmp.y = arr[2];
					}
				}
			} else {
				if (particle.target is MovieClip) {
					var mc:MovieClip = particle.target as MovieClip;
					if(mc.currentFrame != mc.totalFrames) {
						mc.nextFrame();
					} else if (loop) {
						mc.gotoAndStop(1);
					}
				}
			}
		}
	}
}