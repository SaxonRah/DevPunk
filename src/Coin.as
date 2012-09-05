package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import Assets;

	public class Coin extends Entity {
		
		public static var gameCoin:Number = 0;
		
		public function Coin(x:Number, y:Number) {
			
			super(x, y);
			
			type = "coin";
			setHitbox(16, 16);
			graphic = new Image(Assets.SPR_COIN);
		}
		
		override public function update():void {
			
			if (collide("player", x, y)) {
				
				FP.log("Coin Grabbed!");
				gameCoin ++;
				
				world.remove(this);
			}
			super.update();
		}
		public static function getGameCoin() : Number {
			return Coin.gameCoin;
		}
	}
}