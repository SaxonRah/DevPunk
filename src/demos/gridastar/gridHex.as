package  demos.gridastar
{
	import net.flashpunk.graphics.Image;
	import demos.Assets;
	/**
	 * ...
	 * @author Nirvan
	 */
	public class gridHex
	{
		public var parent:int;
		public var F:int;
		public var G:int;
		public var H:int;
		public var status:int;
		public var value:int;
		public var image:Image;
		
		public function gridHex(parent:int, x:int, y:int)
		{
			this.parent = parent;
			//dir = 0;
			F = 0;
			G = 0;
			H = 0;
			status = 0;
			value = 0;
			image = new Image(Assets.HEXIMG);
			image.x = x;
			image.y = y;
		}
		
		public function refresh(i:int, j:int):void
		{
			parent = i;
			F = 0;
			G = 0;
			H = 0;
			status = 0;
			if (j) value = 0;
		}
	}

}