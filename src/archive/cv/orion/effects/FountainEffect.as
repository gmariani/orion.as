package cv.orion.effects {

	import cv.orion.edgefilters.BounceEdgeFilter;
	import cv.orion.filters.DragFilter;
	import cv.orion.filters.FadeFilter;
	import cv.orion.filters.TurnToPathFilter;
	import cv.orion.filters.GravityFilter;
	import cv.orion.emitters.Emitter;
	
	public class FountainEffect {
		public static function apply(emitter:Emitter):void {
			// Initial Particle Settings
			emitter.mass = 1;
			emitter.velocityXMin = -8;
			emitter.velocityXMax = 8;
			emitter.velocityYMin = -15;
			emitter.velocityYMax = -10;
			
			// Filters
			//emitter.setEdgeFilter(new BounceEdgeFilter());
			emitter.addFilter(new GravityFilter(0.5));
			emitter.addFilter(new DragFilter(0.99));
			emitter.addFilter(new FadeFilter(0.955));
			emitter.addFilter(new TurnToPathFilter());
		}
	}
}