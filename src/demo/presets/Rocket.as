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

package demo.presets {
	
	import cv.orion.filters.*;
	
	public class Rocket {
		
		public static function rocket():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.lifeSpan = 1000;
			o.settings.velocityXMin = -2;
			o.settings.velocityXMax = 2;
			o.settings.velocityY = -20;
			
			// Filters
			o.effectFilters = [
								new GravityFilter(0.35),
								new ScaleFilter(0.98),
								new FadeFilter(0.99),
								new TurnToPathFilter()];
			
			return o;
		}
		
		public static function spark():Object {
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
		
		public static function smoke():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.lifeSpan = 1660;
			o.settings.velocityXMin = -0.25;
			o.settings.velocityXMax = 0.25;
			o.settings.opacity = 0.1;
			o.settings.rotate = Math.random() * 360;
			o.settings.scaleMin = 0.25;
			o.settings.scaleMax = 0.5;
			
			// Filters
			o.effectFilters = [
								new ScaleFilter(1.02),
								new FadeFilter(0.98),
								new GravityFilter(-0.03),
								new DragFilter(0.99)];
			
			return o;
		}
		
		public static function flash():Object {
			var o:Object = new Object();
			
			// Initial Particle Settings
			o.settings = new Object();
			o.settings.scale = 8;
			o.settings.lifeSpan = 166;
			
			o.effectFilters = [new FadeFilter(0.6)];
			
			return o;
		}
	}
}