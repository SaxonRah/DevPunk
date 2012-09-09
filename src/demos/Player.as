package demos {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	public class Player extends Entity {
		private const SPEED:int = 100;
		private const G:Image = new Image(Assets.SPR_PLAYER);
		
		public function Player(x:Number, y:Number) {
			super(x, y);
			
			type = "player";
			
			setHitbox(14, 14);
			graphic = G;
		}
		
		override public function update() : void {
			super.update();
			
			if (Input.check(Key.LEFT)) {
				moveBy( -SPEED * FP.elapsed, 0, "level");
				G.flipped = true;
			} else if (Input.check(Key.RIGHT)) {
				moveBy( SPEED * FP.elapsed, 0, "level");
				G.flipped = false;
			}
			
			if (Input.check(Key.UP)) {
				moveBy(0, -SPEED * FP.elapsed, "level");
			} else if (Input.check(Key.DOWN)) {
				moveBy(0, SPEED * FP.elapsed, "level");
			} 
		}
	}
}