package demos.platformer {

    import net.flashpunk.*;
    import net.flashpunk.graphics.*;

    public class PlayerSWDGUY extends Entity {

        public var sprSwordguy:Spritemap;

        public function PlayerSWDGUY(param1:Number, param2:Number) {
		
            this.sprSwordguy = new Spritemap(PlayerSWDGUY, 48, 32);
            super(param1, param2);
            this.sprSwordguy.add("stand", [0, 1, 2, 3, 4, 5], 20, true);
            this.sprSwordguy.add("run", [6, 7, 8, 9, 10, 11], 20, true);
            graphic = this.sprSwordguy;
            return;
        }

        override public function added() : void {
            super.added();
            return;
        }

        override public function update() : void {
            super.update();
            return;
        }
    }
}
