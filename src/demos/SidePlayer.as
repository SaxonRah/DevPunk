package demos 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;

	public class SidePlayer extends Entity
	{
		[Embed(source = '../../assets/swordguy.png')]
		private const SWORDGUY:Class;

		public var sprSwordguy:Spritemap = new Spritemap(SWORDGUY, 48, 32);
		
		public function SidePlayer(x:Number, y:Number)
		{
			super(x, y);
						
			sprSwordguy.add("run", [6, 7, 8, 9, 10, 11], 20, true);
			sprSwordguy.play("run");
			graphic = sprSwordguy;

		}
		
		private var dx:Number = 2;
		override public function update():void
		{
			moveBy(dx, 0);

			if(x > 900) 
			{
				dx = -2;
				sprSwordguy.flipped = true;
			}
			else if(x < 50)
			{
				dx = 2;
				sprSwordguy.flipped = false;
			}
		}
	}
}