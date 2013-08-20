package  punk.lit
{
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Noel Berry
	 */
	public class Light
	{
		public var x:int = 0;
		public var y:int = 0;
		public var scale:Number = 1;
		public var alpha:Number = 1;
		public var image:Image = null;
		public var rotate:Number = 0;
		public var active:Boolean = true;
		
		public function Light(x:int, y:int, image:Image, scale:Number = 1, alpha:Number = 1, rotate:Number = 0, active:Boolean = true) 
		{
			this.x = x;
			this.y = y;
			this.scale = scale;
			this.alpha = alpha;
			this.image = image;
			this.rotate = rotate;
			this.active = active;
		}
	}

}