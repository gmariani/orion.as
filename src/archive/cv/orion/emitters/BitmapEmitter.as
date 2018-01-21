////////////////////////////////////////////////////////////////////////////////
//
//  COURSE VECTOR - GABRIEL MARIANI
//  Copyright 2008 Gabriel Mariani
//  All Rights Reserved.
//
//  NOTICE: Course Vector permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package cv.orion.emitters {
	
	import cv.orion.Particle;
	import cv.orion.emitters.Emitter;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	[IconFile("icons/BitmapEmitterIcon.png")]
	[TagName("Bitmap Emitter")]
	
	//--------------------------------------
    //  Events
    //--------------------------------------
	// None
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The BitmapEmitter class emits particles where ever the specified color is on the parent
	 * of the emitter. The BitmapEmitter takes a snapshot of it's parent when added to the display
	 * list. This image is used while it runs.
	 * 
     * @langversion 3.0
     * @playerversion Flash 9
     */
	public class BitmapEmitter extends Emitter {
		
		/**
		 * If true, it ignores speedX and speedY and randomly chooses a point within
		 * the emitter.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 */
		[Inspectable(defaultValue=false)]
		public var isRandom:Boolean = false;
		
		/**
		 * The X speed that the emitter scans the bitmap and adds particles.
		 * 
		 * @see #speedY
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 */
		[Inspectable(defaultValue=6)]
		public var speedX:Number = 6;
		
		/**
		 * The Y speed that the emitter scans the bitmap and adds particles.
		 * 
		 * @see #speedX
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 */
		[Inspectable(defaultValue=2)]
		public var speedY:Number = 2;
		
		/**
		 * The target color to attach particles to within the bitmap. The default is
		 * white (0xFFFFFF).
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 */
		[Inspectable(defaultValue=0xFFFFFF, type="Color")]
		public var targetColor:Number = 0xFFFFFF;
		
		protected var bmData:BitmapData;
		protected var pHeight:Number;
		protected var point:Point = new Point();
		protected var pWidth:Number;
		protected var scanX:Number = 0;
		protected var ypos:Number = 0;
		protected var xpos:Number;
		protected var _targetObject:DisplayObject;
		protected var stackOverFlowCount:uint = 0;
		protected var offSet:Point = new Point();
		
		public function BitmapEmitter(spriteClass:Class = null, useFrameCaching:Boolean = true) {
			super(spriteClass, useFrameCaching);
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * The display object to use as a reference for the bitmapdata. 
		 * 
		 * @default this.parent
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Property
		 */
		public function get target():DisplayObject { return _targetObject; }
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9
         */
		public function set target(value:DisplayObject):void {
			_targetObject = value;
			updateBitmap();
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Updates the snapshot/bitmapdata of the target display object if it has changed.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		public function updateBitmap():void {
			pWidth = (_targetObject == this.root) ? stage.stageWidth : _targetObject.width;
			pHeight = (_targetObject == this.root) ? stage.stageHeight : _targetObject.height;
			offSet = this.globalToLocal(_targetObject.localToGlobal(new Point(0, 0)));
			setSize(pWidth, pHeight);
			bmData = new BitmapData(pWidth, pHeight, false, 0x000000); 
			bmData.draw(_targetObject);
		}
		
		override public function setSize(width:Number, height:Number):void {
			if (!isLivePreview) {
				_emitter.width = width;
				_emitter.height = height;
			}
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		/**
		 * Returns a coordinate within it's designated area, which is determined by
		 * the target displayobject.
		 * 
		 * @return Returns a random coordinate within it's width and height.
		 * 
		 * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		override protected function getCoordinate():Point {
			if (isRandom) {
				xpos = Math.random() * pWidth;
				ypos = Math.random() * pHeight;
				if (bmData.getPixel(xpos, ypos) == targetColor) {
					point.x = xpos + offSet.x;
					point.y = ypos + offSet.y;
					stackOverFlowCount = 0;
					return point;
				}
				stackOverFlowCount++;
			} else {
				scanX += speedX;
				
				if (scanX >= pWidth) {
					scanX = 0;
					stackOverFlowCount++;
				}
				if (ypos >= pHeight) ypos = 0;
				
				while (ypos < pHeight) {
					ypos += speedY;
					xpos = scanX;// - (ypos / 6); 
					if (xpos > 0) {
						if(bmData.getPixel(xpos, ypos) == targetColor) {
							point.x = xpos + offSet.x;
							point.y = ypos + offSet.y;
							ypos += 10;
							stackOverFlowCount = 0;
							return point;
						}
					}
				}
			}
			
			// Couldn't find the specified color try again til we find the color
			if(stackOverFlowCount < 20) {
				return getCoordinate();
			}
			
			// Break out of infinte loop so it doesn't break
			stackOverFlowCount = 0;
			return null;
		}
		
		/**
		 * @copy cv.orion.emitters.Emitter#stageHandler()
		 * 
		 * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		override protected function stageHandler(event:Event):void {
			if (event.type == Event.ADDED_TO_STAGE) {
				if (!_targetObject) _targetObject = this.parent;
				updateBitmap();
				updateCanvas();
				renderer.update(_target, _canvas);
				enabled = true;
			} else {
				enabled = false;
			}
		}
	}
}