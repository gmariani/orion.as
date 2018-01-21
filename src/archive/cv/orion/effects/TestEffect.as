package cv.orion.effects {

	import cv.orion.filters.FrameFilter;
	import cv.orion.filters.FadeFilter;
	import cv.orion.filters.GravityFilter;
	import cv.orion.emitters.Emitter;
	
	public class TestEffect {
		public static function apply(emitter:Emitter):void {
			// Initial Particle Settings
			emitter.lifeSpan = 1000;
			emitter.velocityXMin = -2;
			emitter.velocityXMax = 2;
			//emitter.velocityYMin = -2;
			//emitter.velocityYMax = 2;
			//emitter.numberOfParticles = 8;
			
			// Filters
			emitter.addFilter(new GravityFilter(0.2));
			//emitter.addFilter(new FadeFilter(0.9));
			emitter.addFilter(new FrameFilter());
		}
	}
}