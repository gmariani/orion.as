/**
* Orion �2009 Gabriel Mariani. February 6th, 2009
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

package cv.orion.presets {
	
	import cv.orion.filters.*;
	
	public class Default {
		
		public static function snow():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.mass = 1;
			o.settings.alpha = 0.8;
			o.settings.lifeSpan = 10000;
			o.settings.velocityXMin = -5;
			o.settings.velocityXMax = 10;
			o.settings.velocityYMin = 1;
			o.settings.velocityYMax = 5;
			
			// Filters
			//o.edgeFilter = new WrapEdgeFilter();
			o.effectFilters = [
								new FadeFilter(.995),
								new WanderFilter(5),
								new GravityFilter(),
								new DragFilter(0.1)];
			
			return o;
		}
		
		public static function smoke():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.alpha = 0.3;
			o.settings.scale = 0.3;
			o.settings.velocityXMin = -0.2;
			o.settings.velocityXMax = 0.2;
			o.settings.velocityY = -1;
			
			// Filters
			o.effectFilters = [
								new ScaleFilter(1.035),
								new FadeFilter(0.96)];
			
			return o;
		}
		
		public static function rain():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.alpha = 0.8;
			o.settings.velocityXMin = -.5;
			o.settings.velocityXMax = .5;
			o.settings.velocityYMin = 1;
			o.settings.velocityYMax = 2;
			
			// Filters
			o.effectFilters = [
								new FadeFilter(.95),
								new WanderFilter(0.5),
								new GravityFilter(),
								new ScaleFilter(0.95)];
			
			return o;
		}
		
		public static function fountain():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.mass = 1;
			o.settings.velocityXMin = -8;
			o.settings.velocityXMax = 8;
			o.settings.velocityYMin = -15;
			o.settings.velocityYMax = -10;
			
			// Filters
			//o.edgeFilter = new BounceEdgeFilter();
			o.effectFilters = [
								new GravityFilter(0.5),
								new DragFilter(0.99),
								new FadeFilter(0.955),
								new TurnToPathFilter()];
			
			return o;
		}
		
		public static function firework():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.alpha = .7;
			o.settings.lifeSpan = 1500;
			o.settings.velocityXMin = -10;
			o.settings.velocityXMax = 10;
			o.settings.velocityYMin = -10;
			o.settings.velocityYMax = 10;
			o.settings.scaleMin = 1;
			o.settings.scaleMax = 2;
			o.settings.colorMin = 0xCC9900;
			o.settings.colorMax = 0xFFFF66;
			//o.settings.numberOfParticles = 8;
			
			// Filters
			o.edgeFilter = new BounceEdgeFilter(-0.5);
			o.effectFilters = [
								new GravityFilter(),
								new ScaleFilter(0.95),
								new ColorFilter(0xCC3300),
								new FadeFilter(0.9)];
			
			return o;
		}
		
		public static function sparkler():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.lifeSpan = 1300;
			o.settings.velocityY = 0;
			o.settings.velocityXMin = 10;
			o.settings.velocityXMax = 20;
			o.settings.velocityAngleMin = 0;
			o.settings.velocityAngleMax = 360;
			o.settings.scaleMin = 1.5;
			o.settings.scaleMax = 2.3;
			o.settings.opacity = 0.1;
			o.settings.rotateMax = 360;
			o.settings.rotateMin = 1;
			o.settings.numberOfParticles = 40;
			
			// Filters
			o.effectFilters = [
								new GravityFilter(0.2),
								new ScaleFilter(0.9),
								new FadeFilter(0.98),
								new DragFilter(0.91),
								new TurnToPathFilter()];
			
			return o;
		}
		
		public static function explode():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.velocityXMin = -20;
			o.settings.velocityXMax = 20;
			o.settings.velocityYMin = -20;
			o.settings.velocityYMax = -10;
			
			// Filters
			o.edgeFilter = new BounceEdgeFilter(-0.5);
			o.effectFilters = [
								new DragFilter(0.97),
								new GravityFilter(0.3)];
			
			return o;
		}
		
		public static function collide():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.lifeSpan = -1;
			o.settings.mass = 30;
			o.settings.velocityXMin = -5;
			o.settings.velocityXMax = 5;
			o.settings.velocityYMin = -5;
			o.settings.velocityYMax = 5;
			
			// Filters
			o.edgeFilter = new BounceEdgeFilter(-1);
			o.effectFilters = [new CollisionFilter()];
			
			return o;
		}
		
		public static function dust():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.mass = 30;
			o.settings.lifeSpan = 10000;
			
			// Filters
			o.edgeFilter = new StopEdgeFilter();
			o.effectFilters = [
								new WanderFilter(0.2),
								new GravityFilter(0.1),
								new MouseGravityFilter(-10)];
			
			return o;
		}
	}
}