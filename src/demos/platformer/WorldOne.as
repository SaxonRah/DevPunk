package demos.platformer 
{
	import flash.display.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
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
	import demos.platformer.*;
	import demos.punkui.*;
	import demos.tinting.*;
	
	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com
	 */	
	public class WorldOne extends World 
	{
		
		
		private var _player:SidePlayer;		
		
		public function WorldOne() 
		{
			FP.log("World One Started");
			
			var img:Image = new Image(Assets.GFX_MAP);
			img.scale = 2;
			addGraphic(img);	
				
			_player = new SidePlayer(400, 0);
			add(_player);	
		}
		
		override public function update():void 
		{
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
			
			FP.camera.x = _player.x - FP.halfWidth;
			FP.camera.y = _player.y - FP.halfHeight;
			FP.clampInRect(FP.camera, 0, 0, 1024 - FP.width, 512 - FP.height);	
		}
		
		// Examples of callbacks
		private function onBlurOutComplete():void 
		{
			trace("Blur Out done!");
		}		
		
		private function onBlurInComplete():void 
		{
			trace("Blur In done!");
		}
		
		public function get player():Entity 
		{
			return _player;
		}
		
	}
}