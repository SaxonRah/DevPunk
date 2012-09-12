package demos.gravityemit {
	
	import flash.display.*;
    import net.flashpunk.*;
    import net.flashpunk.graphics.*;
    import net.flashpunk.utils.*;
	
	public class GravityEmitter extends Entity{
		
		public var e:Emitter;
		
		public function GravityEmitter(param1:Number, param2:Number) {
			
			super(param1, param2);
            this.e = new Emitter(new BitmapData(4, 4, false, 16777215), 4, 4);
            this.e.newType("particle", [0]);
            this.e.setMotion("particle", 0, 0, 0.5, 360, 500, 1, Ease.quadOut);
            this.e.setAlpha("particle");
            this.e.setGravity("particle", 5, 5);
            var _loc_3:* = FP.getColorHSV(Math.random(), 1, 1);
            this.e.setColor("particle", _loc_3, _loc_3);
            graphic = this.e;
            var _loc_4:* = 0;
            while (_loc_4 < 50){
                
                this.e.emit("particle", 0, 0);
                _loc_4++;
            }
            return;
		}
	
		override public function update() : void {
            super.update();
            if (this.e.particleCount < 1) {
                world.remove(this);
            }
            return;
        }
	}
}