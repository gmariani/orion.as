package cv.orion {
	
	import flash.geom.Point;
	
	public final class EmitVO {
		
		public var amount:uint;
		
		public var coord:Point;
		
		public function EmitVO(coord:Point, amount:uint) {
			this.coord = coord;
			this.amount = amount;
		}
	}
}