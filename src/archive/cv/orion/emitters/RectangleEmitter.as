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
	import cv.util.MathUtil;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[IconFile("icons/RectangleEmitterIcon.png")]
	[TagName("Rectangle Emitter")]
	
	//--------------------------------------
    //  Events
    //--------------------------------------
	// None
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The RectangleEmitter class emits particles within a set bounding box. The particles can
	 * either be emitted from the box and move freely. Or be emitted, and be contained within
	 * the bounding box.
	 * 
     * @langversion 3.0
     * @playerversion Flash 9
     */
	public class RectangleEmitter extends Emitter {
		
		 /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _oldCanvas:Rectangle;
		
		 /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _isContained:Boolean = false;
		
		public function RectangleEmitter(spriteClass:Class = null, useFrameCaching:Boolean = true) {
			super(spriteClass, useFrameCaching);
		}
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * Gets or sets whether the particles generated within the box have stay inside the box or not.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0
		 * @category Property
		 */
		public function get isContained():Boolean { return _isContained; }
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9
         */
		[Inspectable(defaultValue=false)]
		public function set isContained(value:Boolean):void {
			_isContained = value;
			if (value) {
				_oldCanvas = _canvas;
			} else {
				if (_oldCanvas) {
					_canvas = _oldCanvas;
					_oldCanvas = null;
				}
			}
		}
		
		override public function setSize(width:Number, height:Number):void {
			_emitter.width = width;
			_emitter.height = height;
			
			if (isLivePreview) {
				var mc:MovieClip = this.getChildAt(0) as MovieClip;
				mc.width = width;
				mc.height = height;
				super.scaleX = 1;
				super.scaleY = 1;
			}
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		/**
		 * Returns a coordinate within it's designated area.
		 * 
		 * @return Returns a random coordinate within it's width and height.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		override protected function getCoordinate():Point {
			return new Point(MathUtil.randomRange(_emitter.left, _emitter.right), MathUtil.randomRange(_emitter.top, _emitter.bottom));
		}
		
		override protected function render(p:Particle):void {
			if (_isContained) _canvas = _emitter;
			super.render(p);
		}
	}
}