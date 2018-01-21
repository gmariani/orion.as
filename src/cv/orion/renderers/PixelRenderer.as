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

package cv.orion.renderers {
	
	import cv.Orion;
	import cv.orion.ParticleVO;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The PixelRenderer class acts exactly like the BitmapRenderer class. The one difference
	 * is that instead of drawing particles to the bitmap, it will draw a single pixel for each
	 * particles in the Orion instance.
     */
	public class PixelRenderer extends BitmapRenderer {
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Instead of getting the bitmap data from the particle. It will instead
		 * draw a single pixel according to the particle's properties. If no
		 * default color is specified (colorMin, colorMax, color) in the config, 
		 * or the color is 0 (black) the particle color will default to white.
		 * 
		 * If you want to specify black as a color and avoid the default
		 * from being used please use a color as close to black as possible.
		 * 
		 * @param	d The particle to get the properties from.
		 * @param	e The emitter being used with the particle.
		 * 
		 * @private (protected)
		 */
		override protected function drawTarget(d:DisplayObject):void {
			if (d is Orion) {
				var e:Orion = d as Orion;
				
				// Loop through all particles
				var i:int = e.particles.length;
				var p:ParticleVO;
				while (i--) {
					p = e.particles[i];
					if(p.active == true) {
						// Maintain alpha of particle
						var hexAlpha:String = Number(p.target.transform.colorTransform.alphaMultiplier * 255).toString(16);
						// 0xCCCCCC = setPixel / 0xFFCCCCCC = setPixel32
						var clr:uint = (p.target.transform.colorTransform.color == 0) ? 0xFFFFFF : p.target.transform.colorTransform.color;
						this.bitmapData.setPixel32(p.target.x, p.target.y, Number("0x" + hexAlpha + clr.toString(16)));
					}
				}
			} else {
				throw Error("PixelRenderer can only be used with instances of Orion");
				return;
			}
		}
	}
}