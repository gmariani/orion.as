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

package cv.orion {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * ParticleVO is a value object class. It contains properties used by each
	 * particle. Having a specific class with the explicit properties helps
	 * the player manage memory usage.
	 */
	public final class ParticleVO {
		
		public function ParticleVO(target:DisplayObject = null) {
			if (target) {
				this.target = target;
				isMovieClip = (target is MovieClip);
			}
		}
		
		public var active:Boolean = false;
		
		public var next:ParticleVO;
		
		/**
		 * The mass of the particle
		 */
		public var mass:Number;
		
		/**
		 * If the particle should not be garbage collected or animated. Used with StopEdgeFilter
		 */
		public var paused:Boolean;
		
		/**
		 * The time stamp on the particle, used to determine the lifespan of each particle running.
		 */
		public var timeStamp:int;
		
		/**
		 * The velocity of the particle. [x, y, z]
		 */
		public var velocityX:Number = 0;
		public var velocityY:Number = 0;
		public var velocityZ:Number = 0;
		
		// For Pixels Only //
		/////////////////////
		
		/**
		 * Used when no target is available
		 */
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		
		// For Display Objects Only //
		//////////////////////////////
		
		/**
		 * Saves time so we don't have to check again
		 */
		public var isMovieClip:Boolean = false;
		
		/**
		 * The actual item on the display list being animated
		 */
		public var target:DisplayObject;
		
		/**
		 * The current frame of the particle. This is saved becuase the particle only has an image of one frame.
		 */
		public var currentFrame:int = 1;
	}
}