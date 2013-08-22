package demos.box2d {
	import punk.box2fp.Box2DEntity;
	
	import punk.box2fp.Box2DShapeBuilder;
	/**
	 * ...
	 * @author Ra
	 */
	public class B2DWall extends Box2DEntity {
		
		public function B2DWall(x:Number, y:Number, w:uint, h:uint) {
			super(x, y, w, h);
		}
		
		override public function buildShapes(friction:Number, density:Number, restitution:Number, group:int, category:int, collmask:int):void {
			Box2DShapeBuilder.buildRectangle(body, width / (2.0 * box2dworld.scale), height / (2.0 * box2dworld.scale), 0.3, 1, 0.3);
		}
	}

}