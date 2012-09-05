package {
	import net.flashpunk.*;
    import punk.ui.*;
    import punk.ui.skins.*;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import Assets;
	import Coin;
	
	public class GameWorld extends World {
		public var txt:*= new PunkTextArea("Coins Collected : " + Coin.getGameCoin(), 400, 400, 175, 175);
		
		public function GameWorld() {
				FP.console.enable();
		}
		
		override public function begin() : void {
			PunkUI.skin = new YellowAfterlife();
			add(txt);
			super.begin();
			add(new Level(Assets.LVL_SAMPLE));
			
		}
		override public function update() : void {
			this.txt.text = "Coins Collected : " + Coin.getGameCoin();
			if (Coin.getGameCoin() >=8) {
				this.txt.text = "You've Won!!!";
			}
			super.update();
		}
		
	}
}