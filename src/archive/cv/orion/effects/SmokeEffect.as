package cv.orion.effects {
	
	import cv.orion.filters.DragFilter;
	import cv.orion.filters.FadeFilter;
	import cv.orion.filters.ScaleFilter;
	import cv.orion.emitters.Emitter;

	public class SmokeEffect {
		public static function apply(emitter:Emitter):void {
			// Initial Particle Settings
			emitter.opacity = 0.3;
			emitter.scale = 0.3;
			emitter.velocityXMin = -0.2;
			emitter.velocityXMax = 0.2;
			emitter.velocityY = -1;
			
			// Filters
			emitter.addFilter(new ScaleFilter(1.035));
			emitter.addFilter(new FadeFilter(0.96));
		}
	}
}