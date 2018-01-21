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

package cv {
	
	import cv.Orion;
	import cv.orion.interfaces.IOutput;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
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
	public class OrionBitmap extends Orion {
		
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
		protected var bmData:BitmapData;
		/** @private **/
		protected var pHeight:Number;
		/** @private **/
		protected var point:Point = new Point();
		/** @private **/
		protected var pWidth:Number;
		/** @private **/
		protected var scanX:Number = 0;
		/** @private **/
		protected var ypos:Number = 0;
		protected var startY:Number = 0;
		/** @private **/
		protected var xpos:Number;
		/** @private **/
		protected var _targetColor:Number = 0xFFFFFF;
		/** @private **/
		protected var _targetObject:DisplayObject;
		/** @private **/
		protected var offSet:Point = new Point();
		/** @private **/
		protected const POINT:Point = new Point();
		/** @private **/
		protected var rectColorBounds:Rectangle;
		/** @private **/
		protected var rectIntersect:Rectangle;
		
		/** @copy cv.Orion#Orion() */
		public function OrionBitmap(spriteClass:Class = null, output:IOutput = null, config:Object = null, useFrameCaching:Boolean = false) {
			super(spriteClass, output, config, useFrameCaching);
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/** @private **/
		override public function set height(value:Number):void {
			super.height = value;
			updateIntersection();
		}
		
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
		public function get targetColor():Number { return _targetColor; }
		
		public function set targetColor(value:Number):void {
			_targetColor = value;
			updateBitmap();
		}
		
		/** @private **/
		override public function set width(value:Number):void {
			super.width = value;
			updateIntersection();
		}
		
		/** @private **/
		override public function set x(value:Number):void {
			super.x = value;
			updateIntersection();
		}
		
		/** @private **/
		override public function set y(value:Number):void {
			super.y = value;
			updateIntersection();
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/** @copy cv.Orion#render() */
		override public function render(e:Event = null):void {
			super.render(e);
			
			// Draw boxes for color bounds
			if (debug) {
				this.graphics.lineStyle(1, 0xFF6600, 1, true);
				this.graphics.drawRect(rectColorBounds.x, rectColorBounds.y, rectColorBounds.width, rectColorBounds.height);
			}
		}
		
		/**
		 * Updates the bitmapdata of the target display object if it has changed.
		 */
		public function updateBitmap():void {
			pWidth = (_targetObject == this.root) ? stage.stageWidth : _targetObject.width;
			pHeight = (_targetObject == this.root) ? stage.stageHeight : _targetObject.height;
			offSet = this.globalToLocal(_targetObject.localToGlobal(POINT));
			bmData = new BitmapData(pWidth, pHeight, false, 0x000000); 
			bmData.draw(_targetObject);
			
			// Reduce area to just the bounds the color exists
			rectColorBounds = bmData.getColorBoundsRect(Number("0xFF" + targetColor.toString(16)), 0, false);
			if(rectColorBounds.height > 0) {
				bmData = new BitmapData(rectColorBounds.width, rectColorBounds.height, false, 0x000000); 
				bmData.draw(_targetObject, null, null, null, rectColorBounds, cacheSmoothing);
			}
			
			updateIntersection();
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		/** @copy cv.Orion#getCoordinate() */
		override protected function getCoordinate():Point {
			// If bounds height is 0, then there is no color to find, skip
			if (rectColorBounds.height > 0 && rectIntersect.height > 0) {
				if (isRandom) {
					xpos = (Math.random() * rectIntersect.width) + rectIntersect.x;
					ypos = (Math.random() * rectIntersect.height) + rectIntersect.y;
					if (bmData.getPixel(xpos, ypos) == targetColor) {
						point.x = xpos + offSet.x;
						point.y = ypos + offSet.y;
						return point;
					}
				} else {
					while (ypos < (rectIntersect.height + rectIntersect.y)) {
						xpos = scanX - (ypos / 4);
						if (xpos > 0) {
							if(bmData.getPixel(xpos, ypos) == targetColor) {
								point.x = xpos + offSet.x;
								point.y = ypos + offSet.y;
								ypos += 10;
								return point;
							}
						}
						
						ypos += speedY;
					}
					
					scanX += speedX;
					if (scanX >= rectIntersect.right) scanX = rectIntersect.x;
					if (ypos >= rectIntersect.bottom) ypos = rectIntersect.top;
				}
			}
			
			return null;
		}
		
		/** @copy cv.Orionr#stageHandler()  */
		override protected function stageHandler(event:Event):void {
			if (event.type == Event.ADDED_TO_STAGE) {
				if (!_targetObject) _targetObject = this.parent;
				updateBitmap();
				this.removeEventListener(Event.ADDED_TO_STAGE, stageHandler);
				this.addEventListener(Event.REMOVED_FROM_STAGE, stageHandler, false, 0, true);
			} else {
				paused = true;
				this.removeEventListener(Event.REMOVED_FROM_STAGE, stageHandler);
				this.addEventListener(Event.ADDED_TO_STAGE, stageHandler, false, 0, true);
			}
		}
		
		/**
		 * Update the intersecting rectangle.
		 * Only emit particles within the emitter and within the bounds of the image.
		 */
		protected function updateIntersection():void {
			if (rectColorBounds) rectIntersect = _emitter.intersection(rectColorBounds);
		}
	}
}