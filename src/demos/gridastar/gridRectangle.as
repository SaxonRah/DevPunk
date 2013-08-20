package  demos.gridastar
{
	/**
	 * ...
	 * @author Nirvan
	 */
	public class gridRectangle
	{
		public var parent:int;
		public var F:int;
		public var G:int;
		public var H:int;
		public var status:int;
		public var value:int;
		//public var dir:int;
		
		public function gridRectangle(parent:int)
		{
			this.parent = parent;
			//dir = 0;
			F = 0;
			G = 0;
			H = 0;
			status = 0;
			value = 0;
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