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
	
	import cv.Orion;
	import cv.orion.emitters.Emitter;
	import cv.orion.Particle;
	import cv.util.ColorUtil;
	import cv.util.GeomUtil;
	import cv.util.MathUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//--------------------------------------
    //  Events
    //--------------------------------------
	// None
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The DisplayObjectEmitter class takes a movieclip and animates the children inside
	 * of it as if they were particles. Does not add any new particles to the system. The 
	 * default canvas is the DisplayObjectCanvas.
	 * 
	 * <p><strong>Note:</strong> The DisplayObjectEmitter cannot use the StageCanvas or Canvas class. 
	 * Currently it's only compatible with the DisplayObjectCanvas class.</p>
	 * 
	 * @see cv.orion.canvases.DisplayObjectCanvas
	 * 
     * @langversion 3.0
     * @playerversion Flash 9
     */
	public class DisplayObjectEmitter extends Emitter {
		
		/**
		 * This offset is used by the BitmapRenderer to fix render issues.
		 * This is set automatically by assignParticles(), but is public to
		 * allow for custom alignment if necessary.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Property
		 */
		public var offSet:Point = new Point();
		
		public function DisplayObjectEmitter() {
			spriteClass = null;
			super(spriteClass, false);
			output = null;
		}
		
		/**
		 * Assigns a particle or the container of the particles to the emitter.
		 * 
		 * @param	target<DisplayObject> The display object to use.
		 * @param	assignChildren<Boolean> Whether to add the target or the children inside the target.
		 * 
		 * @playerversion Flash 9
		 * @langversion 3.0 
		 * @category Method
		 */
		public function assignParticles(target:DisplayObject, assignChildren:Boolean = true):void {
			var b:Rectangle = target.getBounds(this);
			offSet.x = b.x;
			offSet.y = b.y;
			
			var l:int = (assignChildren && target is DisplayObjectContainer) ? DisplayObjectContainer(target).numChildren : 1;
			/*for (var i:int = 0; i < l; i++ ) {
				var p:Particle = (assignChildren && target is DisplayObjectContainer) ? new Particle(DisplayObjectContainer(target).getChildAt(i)) : new Particle(target);
				p.target.cacheAsBitmap = useCacheAsBitmap;
				p.timeStamp = Orion.currentTime;
				rotate = p.rotation;
				p.applySettings(this);
				_particles[p] = p;
			}*/
			
			var i:int = l; 
			while (i--) {
				var p:Particle = (assignChildren && target is DisplayObjectContainer) ? new Particle(DisplayObjectContainer(target).getChildAt(i)) : new Particle(target);
				p.target.cacheAsBitmap = useCacheAsBitmap;
				p.timeStamp = Orion.currentTime;
				p.mass = mass || 1;
				
				if (colorMin >= 0 && colorMax >= 0) {
					p.color = ColorUtil.interpolateColors(colorMin, colorMax, Math.random());
				} else {
					if (color >= 0) {
						p.color = color;
					} else {
						p.color = 0xFFFFFF;
					}
				}
				
				if(opacityMin > 0 && opacityMax > opacityMin) {
					p.alpha = MathUtil.randomRange(opacityMin, opacityMax);
				} else {
					p.alpha = opacity || 1;
				}
				
				if(velocityXMin && velocityXMax) {
					p.velocity.x = MathUtil.randomRange(velocityXMin, velocityXMax);
				} else {
					p.velocity.x = velocityX || 0;
				}
				
				if(velocityYMin && velocityYMax) {
					p.velocity.y = MathUtil.randomRange(velocityYMin, velocityYMax);
				} else {
					p.velocity.y = velocityY || 0;
				}
				
				if(!isNaN(velocityRotateMin) && !isNaN(velocityRotateMax)) {
					p.angularVelocity = MathUtil.randomRange(velocityRotateMin, velocityRotateMax);
				} else {
					p.angularVelocity = velocityRotate || 0;
				}
				
				var angle:Number;
				if (!isNaN(velocityAngleMin) && !isNaN(velocityAngleMax)) {
					angle = MathUtil.randomRange(velocityAngleMin, velocityAngleMax);
				} else {
					angle = velocityAngle || 0;
				}
				if (angle) {
					angle = MathUtil.degreesToRadians(angle);
					p.velocity = GeomUtil.rotateCoord(p.velocity.x, p.velocity.y, Math.sin(angle), Math.cos(angle), false);
				}
				
				if(scaleMin && scaleMax) {
					p.scaleX = p.scaleY = MathUtil.randomRange(scaleMin, scaleMax);
				} else {
					if(scale) p.scaleX = p.scaleY = scale;
				}
				
				_particles.push(p);
			}
		}
	}
}