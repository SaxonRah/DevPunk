package punk.light {
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Time
	 */
	public class Lighting extends Entity {
		//The number of pixels per cell on the lightmaps.
		public static const grid:int = 4;
		//The default darkness of the level.
		public static var minimumDarkness:uint = 0xFF0000;
		//Scales up the pixelized bitmap to the appropriate size to fit the screen.
		private var m:Matrix = new Matrix();
		
		//The main light buffer onto which the static and dynamic lights draw themselves.
		public static var drawLights:BitmapData = new BitmapData(Math.ceil(FP.width / grid), Math.ceil(FP.height / grid), false, 0xFF000000);
		
		//The bitmapdata that holds the positions of blocked areas.
		public static var blocks:BitmapData = new BitmapData(Math.ceil(FP.width / grid), Math.ceil(FP.height / grid), true, 0x00000000);
		
		//The static light buffer that holds the lightmap of non-moving lights.
		public static var staticLights:BitmapData = new BitmapData(Math.ceil(FP.width / grid), Math.ceil(FP.height / grid), false, 0xFF000000);
		
		//The dynamic light buffer that holds the lightmap of moving lights.
		public static var dynamicLights:BitmapData = new BitmapData(Math.ceil(FP.width / grid), Math.ceil(FP.height / grid), false, 0xFF000000);
		
		public function Lighting() {
			super();
			m.scale(grid, grid);
		}
		
		/**
		 * Updates the static lights on screen.
		 * @param	pos		The positions of the change (optional).
		 */
		public static function updateStaticLights(pos:Point = null):void {
			staticLights.fillRect(staticLights.rect, 0xFF000000);
			var v:Vector.<Entity> = new Vector.<Entity>();
			var e:Entity;
			FP.world.getClass(Light, v);
			for each (e in v) {
				//Checks if the distance from the change is within the range of the light so as to merit a change.
				if (!(e as Light).dynamicLight && FP.distance(e.x, e.y, pos.x, pos.y) <= (e as Light).range) {
					(e as Light).updateLight();
				}
			}
		}
		
		public static function updateDynamicLights():void {
			dynamicLights.fillRect(dynamicLights.rect, 0xFF000000);
			var v:Vector.<Entity> = new Vector.<Entity>();
			var e:Entity;
			FP.world.getClass(Light, v);
			for each (e in v) {
				if ((e as Light).dynamicLight) {
					(e as Light).updateLight();
				}
			}
		}
		
		override public function update():void {
			updateDynamicLights();
		}
		
		override public function render():void {
			//Draws both the static and dynamic buffers to the main buffer using a lightening blend mode.
			drawLights.copyPixels(staticLights, staticLights.rect, new Point());
			drawLights.draw(dynamicLights, null, null, BlendMode.LIGHTEN);
			
			//Draws the blocked areas onto the screen (unnecessary)
			FP.buffer.draw(blocks, m);
			
			//Draws the combined static and dynamic buffer with a multiply blend mode.
			FP.buffer.draw(drawLights, m, null, BlendMode.MULTIPLY);
		}
	
	}

}