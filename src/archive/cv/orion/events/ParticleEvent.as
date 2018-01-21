package cv.orion.events {
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ParticleEvent extends Event {
		/**
		 * The ParticleEvent.UPDATE constant defines the value of the type property of an update event object.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 */
		public static var UPDATE:String = "update";
		
		/**
		 * The ParticleEvent.DESTROY constant defines the value of the type property of an destroy event object.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 */
        public static var DESTROY:String = "destroy";
		
		/**
         * The current position of the particle.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
		public var position:Point;
		
		/**
         * The current scale of the particle.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
        public var scale:Number;
		
		/**
         * The current velocity of the particle.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 */
        public var velocity:Point;
		
		/**
		 * The constructor function for the ParticleEvent class.
		 * 
		 * @param	type<String> The type of the event, accessible as Event.type.
		 * @param	bubbles<Boolean> Determines whether the Event object participates in the bubbling stage of the event flow. The default value is false.
		 * @param	cancelable<Boolean> Determines whether the Event object can be canceled. The default values is false.
		 * @param	position<Point> The current position of the particle.
		 * @param	scale<Number> The current scale of the particle.
		 * @param	velocity<Point> The current velocity of the particle.
		 * 
		 * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		public function ParticleEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, position:Point = null, scale:Number = 1, velocity:Point = null) {
			super(type, bubbles, cancelable);
			this.position = position;
			this.scale = scale;
			this.velocity = velocity;
		}
		
		/**
		 * Duplicates an instance of an Event subclass.
		 * 
		 * @return <Event> A new Event object that is identical to the original.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		override public function clone():Event {
			return new ParticleEvent(type, bubbles, cancelable, position, scale, velocity);
		}
		
		/**
		 * Returns a string containing all the properties of the Event object
		 * 
		 * @return  <String> A string containing all the properties of the Event object.
         *
         * @langversion 3.0
         * @playerversion Flash 9
		 * @category Method
		 */
		override public function toString():String {
			return formatToString("ParticleEvent", "type", "bubbles", "cancelable", "position", "scale", "velocity", "eventPhase");
		}
	}
}