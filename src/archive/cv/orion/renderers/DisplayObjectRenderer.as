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

package cv.orion.renderers {
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import cv.Orion;
	import cv.orion.Particle;
	import cv.orion.interfaces.IRenderer;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The DisplayObjectRenderer handles the particles how normal animation is handled in 
	 * flash. In other words, all this class does is add and remove the particles from the
	 * parent display object. All the drawing is handled natively in Flash.
	 */
	public class DisplayObjectRenderer implements IRenderer {
		
		public function DisplayObjectRenderer() { }
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * @copy cv.orion.interfaces.IRenderer#addParticle()
		 */
		public function addParticle(particle:Particle, target:Orion):void {
			target.addChild(particle.target);
		}
		
		/**
		 * @copy cv.orion.interfaces.IRenderer#clear()
		 */
		public function clear():void { }
		
		/**
		 * @copy cv.orion.interfaces.IRenderer#removeParticle()
		 */
		public function removeParticle(particle:Particle):void {
			if(particle.target.parent) particle.target.parent.removeChild(particle.target);
		}
		
		/**
		 * @copy cv.orion.interfaces.IRenderer#render()
		 */
		public function render(emitter:Orion):void { }
		
		/**
		 * @copy cv.orion.interfaces.IRenderer#update()
		 */
		public function update(target:DisplayObjectContainer, canvas:Rectangle):void { }
	}
}