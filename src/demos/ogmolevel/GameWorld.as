package demos.ogmolevel {
	
	import net.flashpunk.*;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
    import punk.ui.*;
    import punk.ui.skins.*;
	import punk.transition.*;
	import punk.transition.effects.*;
	
	import demos.*;
	import demos.Assets;
	import demos.bloomnblur.*;
	import demos.bloomnblur.bloom.*;
	import demos.bloomnblur.blur.*;
	import demos.gravityemit.*;
	import demos.lighting.*;
	import demos.ogmolevel.*;
	import demos.ogmolevel.Level;
	import demos.platformer.*;
	import demos.punkui.*;
	import demos.tinting.*;
	
	public class GameWorld extends World {
		public var txtA:*= new PunkTextArea("Coins Collected : " + Coin.getGameCoin(), 400, 400, 175, 50);
		
		public function GameWorld() {
			FP.log("OgmoWorld Started");
			Coin.setGameCoin();
		}
		
		override public function begin() : void {
			super.begin();
			PunkUI.skin = new Elite();
			add(txtA);
			
			add(new Level(Assets.LVL_SAMPLE));
			
		}
		override public function update() : void {
			this.txtA.text = "Coins Collected : " + Coin.getGameCoin();
			if (Coin.getGameCoin() >=8) {
				this.txtA.text = "You've Won!!!\nCoins Collected : " + Coin.getGameCoin();
			}
			
			// Check which Key has been pressed
			if(Input.pressed(Key.X)) {
				Assets.updateWorld(true);
			} else if (Input.pressed(Key.Z)) {
				Assets.updateWorld(false);
			}
			
			super.update();
			
			if (Input.mousePressed) {
				add(new GravityEmitter(Input.mouseX, Input.mouseY));
			}
			
		}
		
		private function onBlurOutComplete():void 
		{
			trace("Blur Out done!");
		}		
		
		private function onBlurInComplete():void 
		{
			trace("Blur In done!");
		}
		
	}
}