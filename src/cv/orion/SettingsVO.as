package cv.orion {
	
	public final class SettingsVO {
		
		/**
		 * The lifespan of the particle in milliseconds. After that time is up, it is removed from display. (In milliseconds)
		 */
		public var lifeSpan:uint = 5000;
		
		/**
		 * The mass of a particle. The larger, the harder it is to move.
		 */
		public var mass:Number = 1;
		
		/**
		 * The initial alpha of a particle. From 0 to 1.
		 */
		public var alpha:Number = 1;
		
		/**
		 * The minimum alpha in a range for the particle randomly initially. From 0 to 1.
		 */
		public var alphaMin:Number = 1;
		
		/**
		 * The maximum alpha in a range for the particle randomly initially. From 0 to 1.
		 */
		public var alphaMax:Number = 1;
		
		/**
		 * The initial X velocity of a particle.
		 */
		public var velocityX:Number = 0;
		
		/**
		 * The minimum X velocity in a range to move the particle randomly initially.
		 */
		public var velocityXMin:Number = 0;
		
		/**
		 * The maximum X velocity in a range to move the particle randomly initially.
		 */
		public var velocityXMax:Number = 0;
		
		/**
		 * The initial Y velocity of a particle.
		 */
		public var velocityY:Number = 0;
		
		/**
		 * The minimum Y velocity in a range to move the particle randomly initially.
		 */
		public var velocityYMin:Number = 0;
		
		/**
		 * The maximum Y velocity in a range to move the particle randomly initially.
		 */
		public var velocityYMax:Number = 0;
		
		/**
		 * The initial spinning velocity of a particle.
		 */
		public var velocityRotate:Number = 0;
		
		/**
		 * The minimum spin in a range to spin the particle randomly initially.
		 */
		public var velocityRotateMin:Number = 0;
		
		/**
		 * The maximum spin in a range to spin the particle randomly initially.
		 */
		public var velocityRotateMax:Number = 0;
		
		/**
		 * The direction the particle will move in. From 0 to 360.
		 */
		public var velocityAngle:Number = 0;
		
		/**
		 * The minimum angle in a range to move in a random direction. From 0 to 360.
		 */
		public var velocityAngleMin:Number = 0;
		
		/**
		 * The maximum angle in a range to move in a random direction. From 0 to 360.
		 */
		public var velocityAngleMax:Number = 0;
		
		/**
		 * The initial rotation of a particle. From 0 to 360.
		 */
		public var rotate:Number = 0;
		
		/**
		 * The minimum rotation in a range to rotate the particle randomly initially. From 0 to 360.
		 */
		public var rotateMin:Number = 0;
		
		/**
		 * The maximum rotation in a range to rotate the particle randomly initially. From 0 to 360.
		 */
		public var rotateMax:Number = 0;
		
		/**
		 * The initial scale of a particle.
		 */
		public var scale:Number = 1;
		
		/**
		 * The minimum scale in a range to scale the particle randomly initially.
		 */
		public var scaleMin:Number = 1;
		
		/**
		 * The maximum scale in a range to scale the particle randomly initially.
		 */
		public var scaleMax:Number = 1;
		
		/**
		 * The initial tint of a particle.
		 */
		public var color:Number;
		
		/**
		 * The minimum color in a range to tint the particle randomly initially.
		 */
		public var colorMin:Number = 0;
		
		/**
		 * The maximum color in a range to tint the particle randomly initially.
		 */
		public var colorMax:Number = 0;
		
		/**
		 * If a frame is randomly selected initially.
		 */
		public var selectRandomFrame:Boolean = false;
		
		/**
		 * How many particles to create each time a particle is emitted.
		 */
		public var numberOfParticles:uint = 1;
	}
}