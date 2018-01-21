package cv.orion.events {
	
	import cv.orion.ParticleVO;
	import flash.events.Event;
	
	public class ParticleEvent extends Event {
		
		public static const BORN:String = "born";
		public static const DIED:String = "died";
		public static const UPDATE:String = "update";
		
		public var particle:ParticleVO;
		
		public function ParticleEvent(type:String, particle:ParticleVO = null, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			this.particle = particle;
		} 
		
		public override function clone():Event { 
			return new ParticleEvent(type, particle, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ParticleEvent", "type", "particle", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}