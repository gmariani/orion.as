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

package cv.orion.interfaces {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * Implement the IEdgeFilter interface to create a custom edge filter. 
	 * An edge filter determines what happens when a particle hits the edge
	 * of a canvas. Some examples could be that the particle bounces back,
	 * or wraps around to the other side or is just removed. 
	 * 
	 * These are some of the basice edge filters already included with Orion.
	 * But creating a custom filter gives complete flexibility.
	 * 
	 * @see cv.orion.edgefilters.BounceEdgeFilter
	 * @see cv.orion.edgefilters.StopEdgeFilter
	 * @see cv.orion.edgefilters.WrapEdgeFilter
     *
     * @langversion 3.0
     * @playerversion Flash 9
	 */
	public interface IEdgeFilter {
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Applies the specified filter to a particular particle. 
		 * 
		 * @param	particle<Particle> The individual particle.
		 * @param	target<DisplayObjectContainer> The target to get bounds from.
		 * @param	canvas<Canvas> The current canvas the particle is bound by.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 */
		function applyFilter(particle:DisplayObject, target:DisplayObjectContainer, canvas:Rectangle):void;
	}
}