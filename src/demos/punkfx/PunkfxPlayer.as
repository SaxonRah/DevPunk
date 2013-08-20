package demos.punkfx
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import punk.fx.graphics.FXSpritemap;
	import demos.Assets;
	public class PunkfxPlayer extends Entity
	{

		public var sprSwordguy:FXSpritemap = new FXSpritemap(Assets.SWORDGUY, 48*2*1.5, 32*2*1.5);
		
		public var dx:Number = 120;

		public function PunkfxPlayer(x:Number, y:Number)
		{
			super(x, y);
						
			sprSwordguy.add("run", [6, 7, 8, 9, 10, 11], 20, true);
			sprSwordguy.play("run");
			graphic = sprSwordguy;
			width = sprSwordguy.width;
			height = sprSwordguy.height;
			sprSwordguy.scale = 1;
			sprSwordguy.rate = .5;
			sprSwordguy.centerOO();
		}
		
		override public function update():void
		{
			moveBy(dx*FP.elapsed, 0);
			
			if(x > 500) 
			{
				dx *= -1;
				x = 500;
				sprSwordguy.flipped = true;
			} else if(x < 200)
			{
				dx *= -1;
				x = 200;
				sprSwordguy.flipped = false;
			}
		}
	}
}