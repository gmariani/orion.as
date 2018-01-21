package cv.orion.effects {
	
	import cv.orion.edgefilters.WrapEdgeFilter;
	import cv.orion.filters.DragFilter;
	import cv.orion.filters.FadeFilter;
	import cv.orion.filters.WanderFilter;
	import cv.orion.filters.GravityFilter;
	import cv.orion.emitters.Emitter;

	public class SnowEffect {
		public static function apply(emitter:Emitter):void {
			// Initial Particle Settings
			emitter.mass = 1;
			emitter.opacity = 0.8;
			emitter.lifeSpan = 10000;
			emitter.velocityXMin = -5;
			emitter.velocityXMax = 10;
			emitter.velocityYMin = 1;
			emitter.velocityYMax = 5;
			
			// Filters
			emitter.setEdgeFilter(new WrapEdgeFilter());
			emitter.addFilter(new FadeFilter(.995));
			emitter.addFilter(new WanderFilter(5));
			emitter.addFilter(new GravityFilter());
			emitter.addFilter(new DragFilter(0.1));
		}
	}
}