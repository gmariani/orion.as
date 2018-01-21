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

package cv.orion.targets {
	
	import cv.orion.interfaces.ITarget;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * OrionBitmap emits particles where ever the specified color is on the parent
	 * of the emitter. OrionBitmap takes a snapshot of it's parent when added to the display
	 * list. This image is used while it runs.
     */
	public class BitmapTarget implements ITarget {
		
		/** @private **/
		protected const _pt:Point = new Point();
		/** @private **/
		protected const POINT:Point = new Point();
		
		/**
		 * If true, it ignores speedX and speedY and randomly chooses a point within
		 * the emitter.
		 * 
		 * @default false
		 */
		public var isRandom:Boolean = false;
		
		/**
		 * The X speed that the emitter scans the bitmap and adds particles.
		 * 
		 * @default 6
		 * @see OrionBitmap#speedY
		 */
		public var speedX:Number = 6;
		
		/**
		 * The Y speed that the emitter scans the bitmap and adds particles.
		 * 
		 * @default 2
		 * @see OrionBitmap#speedX
		 */
		public var speedY:Number = 2;
		
		/** @private **/
		protected var _bmpData:BitmapData;
		/** @private **/
		protected var _offSet:Point = new Point();
		/** @private **/
		protected var _colorBnds:Rectangle;
		/** @private **/
		protected var _scanX:Number = 0;
		/** @private **/
		protected var _targetColor:uint = 0xFFFFFF;
		/** @private **/
		protected var _targetObject:DisplayObject;
		/** @private **/
		protected var _xpos:Number;
		/** @private **/
		protected var _ypos:Number = 0;
		
		public function BitmapTarget(target:DisplayObject, targetColor:uint, speedX:Number = 5, speedY:Number = 2, isRandom:Boolean = false) {
			_targetObject = target;
			_targetColor = targetColor;
			this.speedX = speedX;
			this.speedY = speedY;
			this.isRandom = isRandom;
			updateBitmap();
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * The display object to use as a reference for the bitmapdata. This is the object
		 * that is actually drawn from and the dimensions are grabbed from. If no target is
		 * specified, then it will default to the parent of the emitter.
		 * 
		 * @default this.parent
		 */
		public function get target():DisplayObject { return _targetObject; }
		/** @private  */
		public function set target(value:DisplayObject):void {
			_targetObject = value;
			updateBitmap();
		}
		
		/**
		 * The target color to attach particles to within the bitmap.
		 * 
		 * @default 0xFFFFFFFF
		 */
		public function get targetColor():uint { return _targetColor; }
		
		public function set targetColor(value:uint):void {
			_targetColor = value;
			updateBitmap();
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		public function getCoordinate():Point {
			// If bounds height is 0, then there is no color to find, skip
			if (_colorBnds && _colorBnds.height > 0) {
				if (isRandom) {
					_xpos = (Math.random() * _colorBnds.width) + _colorBnds.x;
					_ypos = (Math.random() * _colorBnds.height) + _colorBnds.y;
					if (_bmpData.getPixel(_xpos, _ypos) == targetColor) {
						_pt.x = _xpos + _offSet.x;
						_pt.y = _ypos + _offSet.y;
						return _pt;
					}
				} else {
					while (_ypos < (_colorBnds.height + _colorBnds.y)) {
						_xpos = _scanX - (_ypos / 4);
						if (_xpos > 0) {
							if(_bmpData.getPixel(_xpos, _ypos) == targetColor) {
								_pt.x = _xpos + _offSet.x;
								_pt.y = _ypos + _offSet.y;
								_ypos += 10;
								return _pt;
							}
						}
						
						_ypos += speedY;
					}
					
					_scanX += speedX;
					if (_scanX >= _colorBnds.right) _scanX = _colorBnds.x;
					if (_ypos >= _colorBnds.bottom) _ypos = _colorBnds.top;
				}
			}
			
			return null;
		}
		
		/** @copy cv.Orion#render() */
		/*override public function render(e:Event = null):void {
			super.render(e);
			
			// Draw boxes for color bounds
			if (debug) {
				this.graphics.lineStyle(1, 0xFF6600, 1, true);
				this.graphics.drawRect(_colorBnds.x, _colorBnds.y, _colorBnds.width, _colorBnds.height);
			}
		}*/
		
		/**
		 * Updates the bitmapdata of the target display object if it has changed.
		 */
		public function updateBitmap():void {
			var pWidth:Number = (_targetObject == this.root) ? stage.stageWidth : _targetObject.width;
			var pHeight:Number = (_targetObject == this.root) ? stage.stageHeight : _targetObject.height;
			_offSet = this.globalToLocal(_targetObject.localToGlobal(POINT));
			_bmpData = new BitmapData(pWidth, pHeight, false, 0x000000); 
			_bmpData.draw(_targetObject);
			
			// Reduce area to just the bounds the color exists
			_colorBnds = _bmpData.getColorBoundsRect(Number("0xFF" + targetColor.toString(16)), 0, false);
			if(_colorBnds.height > 0) {
				_bmpData = new BitmapData(_colorBnds.width, _colorBnds.height, false, 0x000000); 
				_bmpData.draw(_targetObject, null, null, null, _colorBnds, cacheSmoothing);
			}
		}
	}
}