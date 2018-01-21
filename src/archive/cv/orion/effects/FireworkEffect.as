package cv.orion.effects {

	import cv.orion.edgefilters.BounceEdgeFilter;
	import cv.orion.filters.ColorFilter;
	import cv.orion.filters.FadeFilter;
	import cv.orion.filters.GravityFilter;
	import cv.orion.filters.ScaleFilter;
	import cv.orion.emitters.Emitter;
	
	public class FireworkEffect {
		public static function apply(emitter:Emitter):void {
			// Initial Particle Settings
			emitter.opacity = .7;
			emitter.lifeSpan = 1500;
			emitter.velocityXMin = -10;
			emitter.velocityXMax = 10;
			emitter.velocityYMin = -10;
			emitter.velocityYMax = 10;
			emitter.scaleMin = 1;
			emitter.scaleMax = 2;
			//emitter.colorMin = 0xCC9900;
			//emitter.colorMax = 0xFFFF66;
			//emitter.numberOfParticles = 8;
			
			// Filters
			emitter.setEdgeFilter(new BounceEdgeFilter(-0.5));
			emitter.addFilter(new GravityFilter());
			emitter.addFilter(new ScaleFilter(0.95));
			emitter.addFilter(new FadeFilter(0.9));
			//emitter.addFilter(new ColorFilter(0xCC3300));
		}
	}
}