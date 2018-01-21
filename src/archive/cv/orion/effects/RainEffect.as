package cv.orion.effects {
	
	import cv.orion.filters.FadeFilter;
	import cv.orion.filters.GravityFilter;
	import cv.orion.filters.WanderFilter;
	import cv.orion.filters.ScaleFilter;
	import cv.orion.emitters.Emitter;
	
	public class RainEffect {
		public static function apply(emitter:Emitter):void {
			// Initial Particle Settings
			emitter.opacity = 0.8;
			emitter.velocityXMin = -.5;
			emitter.velocityXMax = .5;
			emitter.velocityYMin = 1;
			emitter.velocityYMax = 2;
			
			// Filters
			emitter.addFilter(new FadeFilter(.95));
			emitter.addFilter(new WanderFilter(0.5));
			emitter.addFilter(new GravityFilter());
			emitter.addFilter(new ScaleFilter(0.95));
		}
	}
}