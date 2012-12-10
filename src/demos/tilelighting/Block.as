package demos.tilelighting 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author alex larioza
	 */
	public class Block extends Entity 
	{
		
		public function Block(x:Number, y:Number) 
		{
			super(x, y);
			
			type = "block";
			
			graphic = new Image(new BitmapData(LightWorld.TILE_SIZE, LightWorld.TILE_SIZE, false, 0x550000));
			
			setHitbox(LightWorld.TILE_SIZE, LightWorld.TILE_SIZE);
		}
		
		override public function added():void 
		{
			super.added();
			
			LightWorld(world).lighting.setBlockLight(x / LightWorld.TILE_SIZE, y / LightWorld.TILE_SIZE, true);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			LightWorld(world).lighting.setBlockLight(x / LightWorld.TILE_SIZE, y / LightWorld.TILE_SIZE, false);
		}
		
	}

}