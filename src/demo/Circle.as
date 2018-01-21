package demo {
	
	import flash.display.MovieClip;
	
	public class Circle extends MovieClip {
		public function Circle() {
			this.graphics.beginFill(0xFFFFFF, 1);
			this.graphics.lineStyle(1, 0, 1);
			this.graphics.drawCircle(0, 0, 10);
			this.graphics.endFill();
			this.graphics.moveTo(-10, 0);
			this.graphics.lineTo(-10, 0);
			this.graphics.lineTo(10, 0);
			this.graphics.moveTo(0, -10);
			this.graphics.lineTo(0, -10);
			this.graphics.lineTo(0, 10);
		}
	}
}