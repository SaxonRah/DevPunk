package demos.box2d {
	import punk.box2fp.Box2DEntity;
	import punk.box2fp.Box2DShapeBuilder;
	
	import Box2D.Dynamics.b2Body;
	
	import punk.box2fp.graphics.SuperGraphiclist;
	import net.flashpunk.graphics.Image;
	import demos.Assets;
	public class B2DCircleEntity extends B2DEntity {
		
		public function B2DCircleEntity(x:Number, y:Number) {
			super(x, y);
			var coin:Image = new Image(Assets.SPR_COIN);
			coin.centerOrigin();
			(graphic as SuperGraphiclist).add(coin)
		}

		override public function buildShapes(friction:Number, density:Number, restitution:Number, group:int, category:int, collmask:int):void {
			Box2DShapeBuilder.buildCircle(body, width / (10 * box2dworld.scale) + height / (10 * box2dworld.scale), 0.3, 1, 0.3);
		}
		override public function added():void {
			super.added();
			body.SetAngularVelocity(2);
		}
		override public function update():void {
			super.update();
		}
	}
}