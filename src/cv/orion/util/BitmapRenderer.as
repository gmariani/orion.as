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

package cv.orion.util {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The BitmapRenderer actually draws the particles and all the animations as a single bitmap.
	 * This allows you to enabled filters to give really interesting effects which woudl only be
	 * possible as a bitmap.
     */
	public class BitmapRenderer extends Bitmap {
		
		/**
		 * Turns on debug lines to outline the emitter and canvas dimensions
		 */
		public var debug:Boolean = false;
		
		/**
		 * Filters that will be applied before new particles are drawn to the bitmap.
		 */
		public var preFilters:Vector.<BitmapFilter> = new Vector.<BitmapFilter>();
		
		/**
		 * Fitlers that will be applied after new particles have been drawn to the bitmap.
		 */
		public var postFilters:Vector.<BitmapFilter> = new Vector.<BitmapFilter>();
		
		/**
		 * An vector of items to be drawn to th renderer.
		 */
		public var drawTargets:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		/** @private  */
		protected const POINT:Point = new Point();
		/** @private  */
		protected var _palletteMap:Vector.<Array>;
		/** @private */
		protected var _paused:Boolean = false;
		/** @private */
		protected const _shape:Shape = new Shape();
		
		public function BitmapRenderer(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false) {
			super(bitmapData, pixelSnapping, smoothing);
			this.addEventListener(Event.ENTER_FRAME, render, false, 0, true);
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * Gets or sets the paused property
		 */
		public function get paused():Boolean { return _paused; }
		/** @private **/
		public function set paused(value:Boolean):void {
			if (value == _paused) return;
			render(); // Render one more time if being paused
			_paused = value;
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Gets the palletemap if it was set. If it wasn't set, it will just 
		 * return an empty or null array.
		 * 
		 * @return An array of the pallette colors.
		 */
		public function getPalletteMap():Vector.<Array> { return _palletteMap; }
		
		/**
		 * Pauses the renderer
		 */
		public function pause():void {
			this.paused = true;
		}
		
		/**
		 * Resumes or plays the renderer
		 */
		public function play():void {
			this.paused = false;
		}
		
		/**
		 * Calls the renderer to draw the particles.
		 * 
		 * @param	emitter The emitter associated with the particles.
		 */
		public function render(e:Event = null):void {
			if (_paused) return;
			
			var _bitmapData:BitmapData = this.bitmapData;
			
			if (!this.bitmapData) {
				trace("BitmapRenderer::render - Error: bitmapData is null");
				return;
			}
			
			_bitmapData.lock();
			
			// Apply pre filters
			var i:int = preFilters.length;
			if (i <= 0) {
				_bitmapData.fillRect(_bitmapData.rect, 0x000000);
			} else {
				while (i--) {
					_bitmapData.applyFilter(_bitmapData, _bitmapData.rect, POINT, preFilters[i]);
				}
			}
			
			// Draw Targest
			i = drawTargets.length;
			if(i > 0) {
				while (i--) {
					_bitmapData.draw(drawTargets[i], drawTargets[i].transform.matrix, drawTargets[i].transform.colorTransform, drawTargets[i].blendMode, null, this.smoothing);
				}
			}
			
			// Apply post filters
			i = postFilters.length;
			if(i > 0){
				while (i--) {
					_bitmapData.applyFilter(_bitmapData, _bitmapData.rect, POINT, postFilters[i]);
				}
			}
			
			if(_palletteMap) _bitmapData.paletteMap(_bitmapData, _bitmapData.rect, POINT, _palletteMap[1] , _palletteMap[2] , _palletteMap[3] , _palletteMap[0]);
			_bitmapData.unlock();
			
			// Draw boundry lines for debug purposes
			if (debug) {
				_shape.graphics.clear();
				_shape.graphics.lineStyle(1, 0x0000FF, 1, true);
				_shape.graphics.drawRect(this.x, this.y, this.width, this.height);
				_shape.graphics.moveTo(this.x, this.y);
				_shape.graphics.lineTo(this.x, this.y);
				_shape.graphics.lineTo(this.x + this.width, this.y + this.height);
				_shape.graphics.moveTo(this.x + this.width, this.y);
				_shape.graphics.lineTo(this.x + this.width, this.y);
				_shape.graphics.lineTo(this.x, this.y + this.height);
				_bitmapData.draw(_shape);
			}
		}
		
		/**
		 * Remaps the color channel values in an image that has up to four arrays of color 
		 * palette data, one for each channel.
		 * 
		 * @param	red If redArray is not null, red = redArray[source red value] else red = source rect value.
		 * @default null
		 * 
		 * @param	green If greenArray is not null, green = greenArray[source green value] else green = source green value.
		 * @default null
		 * 
		 * @param	blue If blueArray is not null, blue = blueArray[source blue value] else blue = source blue value.
		 * @default null
		 * 
		 * @param	alpha If alphaArray is not null, alpha = alphaArray[source alpha value] else alpha = source alpha value.
		 * @default null
		 */
		public function setPalletteMap(red:Array = null, green:Array = null, blue:Array = null, alpha:Array = null):void {
			if (red == null && green == null && blue == null && alpha == null) {
				_palletteMap = null;
				return;
			}
			
			_palletteMap = new Vector.<Array>(4, true);
			_palletteMap[0] = alpha;
			_palletteMap[1] = red;
			_palletteMap[2] = green;
			_palletteMap[3] = blue;
		}
	}
}