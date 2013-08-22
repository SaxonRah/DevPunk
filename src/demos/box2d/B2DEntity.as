package demos.box2d {
	import net.flashpunk.graphics.Image;
	import punk.box2fp.Box2DEntity;
	import punk.box2fp.Box2DShapeBuilder;
	import punk.box2fp.graphics.SuperGraphiclist;
	
	import Box2D.Dynamics.b2Body;
	
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	
	import demos.Assets;
	
	/**
	 * ...
	 * @author Ra
	 */
	public class B2DEntity extends Box2DEntity {
		
		public function B2DEntity(x:Number, y:Number) {
			super(x, y, 30, 30, b2Body.b2_dynamicBody);
		}
		
		override public function buildShapes(friction:Number, density:Number, restitution:Number, group:int, category:int, collmask:int):void {
			Box2DShapeBuilder.buildRectangle(body, width / (2.0 * box2dworld.scale), height / (2.0 * box2dworld.scale), 0.3, 1, 0.3);
		}
		
		override public function update():void {
			super.update();
			/*
			var input:int = 0;
			input = 0;
			
			if (Input.check(Key.LEFT)) {
				input = -1;
				this.x - this.x * input;
			}
			if (Input.check(Key.RIGHT)) {
				input = 1;
				this.x + this.x * input;
			}
			if (Input.pressed(Key.UP) || Input.pressed(Key.SPACE)) {
				jump();
			}
			*/
		}
		override public function added():void {
			super.added();
			body.SetAngularVelocity(2);
		}
	}
}