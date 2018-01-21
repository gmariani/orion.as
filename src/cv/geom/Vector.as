package cv.geom {
	
	import flash.geom.Point;
	
	public class Vector extends Point {
		
		public var z:Number;
		
		public function Vector(x:Number = 0, y:Number = 0, z:Number = 0) {
			this.z = z;
			super(x, y);
		}
		
		override public function add(v:Vector):Vector {
			var v1:Vector = clone();
			v1.x += v.x;
			v1.y += v.y;
			v1.z += v.z;
			return v1;
		}
		
		override public function clone():Point {
			return new Vector(x, y, z);
		}
		
		override public function offset(dx:Number, dy:Number, dz:Number):void {
			super.offset(dx, dy);
			z += dz;
		}
		
		override public function subtract(v:Point):Point {
			var v1:Vector = clone();
			v1.x -= v.x;
			v1.y -= v.y;
			v1.z -= v.z;
			return v1;
		}
		
		override public function toString():String {
			return "(x=" + x + ", y=" + y + ", z=" + z + ")";
		}
	}
}