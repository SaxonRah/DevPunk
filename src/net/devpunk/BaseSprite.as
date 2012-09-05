package net.devpunk {
	
	import flash.display.Sprite;
	
	public class BaseSprite extends Sprite {
		
		public function BaseSprite() {
			init();
		}
		
		private function init():void {
		// sample code goes here
		graphics.beginFill(0xff0000);
		graphics.drawEllipse(100, 100, 100, 100);
		graphics.endFill();
		}
	}
}