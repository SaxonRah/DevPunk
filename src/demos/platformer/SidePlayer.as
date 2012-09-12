package demos.platformer {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.*;
	import net.flashpunk.*;
	import net.flashpunk.FP;
	import demos.Assets;
	
	
	public class SidePlayer extends Entity {
		
		public var sprSwordguy:Spritemap = new Spritemap(Assets.SWORDGUY, 48, 32);

		// const and vars
		protected const SidePlayer_Speed:int = 175;
		protected const SidePlayer_Jump:int = -300;
		protected const SidePlayer_AttackSize:uint = 1;
		protected var SidePlayer_Gravity:int = 9;
		protected var SidePlayer_Attacking:Boolean = false;
		protected var SidePlayer_Emit:Emitter;
		protected var acceleration:Point;
		protected var velocity:Point;
		
		
		// Constructor
		public function SidePlayer(x:Number, y:Number) {
			super(x, y);

			sprSwordguy.add("idle", [1, 2, 3, 4, 5], 20, true);
			sprSwordguy.add("run", [6, 7, 8, 9, 10, 11], 20, true);
			sprSwordguy.play("idle");
			graphic = sprSwordguy;
			setHitbox(48,32);
			
			SidePlayer_Emit = new Emitter(new BitmapData(16, 16), 16, 16);
			SidePlayer_Emit.newType("attack"), [0];
			SidePlayer_Emit.relative = false; // don't draw relitive to the entity that you are apart of
			SidePlayer_Emit.setColor("attack", 0xFFFFFF, 0xFFFFFF);
			SidePlayer_Emit.setAlpha("attack", 1, 1);
			SidePlayer_Emit.setMotion("attack", 0, 0, 0, 360, 1000, 2, Ease.quadOut);
			
			acceleration = new Point();
			velocity = new Point();
		}
		
		override public function update() : void {
			
			// check player left and right, update animations
			var input:int = 0;
			input = 0;
			SidePlayer_Attacking = false;
			
			if (Input.check(Key.LEFT)) {
				input -= 1;
				sprSwordguy.flipped = true;
				sprSwordguy.play("run");
			}
			
			if (Input.check(Key.RIGHT)) {
				input += 1;
				sprSwordguy.flipped = false;
				sprSwordguy.play("run");
			}
			
			if (Input.pressed(Key.UP) || Input.pressed(Key.SPACE)) {
				jump();
			}
			
			if (Input.pressed(Key.Z)) {
				attack();
				
			}
			
			if (input == 0) {
				sprSwordguy.play("idle");
			}
			
			// update physics and player stuff
			acceleration.y = SidePlayer_Gravity;
			velocity.y += acceleration.y;
			velocity.x = SidePlayer_Speed * input;
			
			// Apply physics and update player based on such
			this.x += velocity.x * FP.elapsed;
			this.y += velocity.y * FP.elapsed;
			
			// collision check
			if (y + height > FP.screen.height - 180) {
				velocity.y = 0;
				y = FP.screen.height - height - 180;
			}
			// parent
			super.update();
		}
		
		protected function jump() : void {
			if (y + height >= FP.screen.height - 180) {
				velocity.y = SidePlayer_Jump;
				FP.log("Jumping");
			}
		}
		
		protected function attack() : void {
			if (SidePlayer_Attacking == false) {	
				for (var loop:uint = 0; loop < SidePlayer_AttackSize; loop++ ) {
					SidePlayer_Attacking = true;
					FP.log("Attacking");
				}
			}
		}
	}
}