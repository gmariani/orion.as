package cv.orion.effects {
	
	import cv.orion.edgefilters.BounceEdgeFilter;
	import cv.orion.filters.DragFilter;
	import cv.orion.filters.GravityFilter;
	import cv.orion.emitters.Emitter;
	
	public class ExplodeEffect {
		public static function apply(emitter:Emitter):void {
			// Initial Particle Settings
			emitter.velocityXMin = -20;
			emitter.velocityXMax = 20;
			emitter.velocityYMin = -20;
			emitter.velocityYMax = -10;
			
			// Filters
			emitter.setEdgeFilter(new BounceEdgeFilter(-0.5));
			emitter.addFilter(new DragFilter(0.97));
			emitter.addFilter(new GravityFilter(0.3));
		}
	}
}