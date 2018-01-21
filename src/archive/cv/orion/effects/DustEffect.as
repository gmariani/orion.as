package cv.orion.effects {
	
	import cv.orion.edgefilters.StopEdgeFilter;
	import cv.orion.filters.MouseRepelFilter;
	import cv.orion.filters.WanderFilter;
	import cv.orion.filters.GravityFilter;
	import cv.orion.emitters.Emitter;

	public class DustEffect {
		public static function apply(emitter:Emitter):void {
			// Initial Particle Settings
			emitter.mass = 30;
			emitter.lifeSpan = 10000;
			
			// Filters
			emitter.setEdgeFilter(new StopEdgeFilter());
			emitter.addFilter(new WanderFilter(0.2));
			emitter.addFilter(new GravityFilter(0.1));
			emitter.addFilter(new MouseRepelFilter(10));
		}
	}
}