package demos.lighting {
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.World;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.*;
	import punk.transition.*;
	import punk.transition.effects.*;
	
	import punk.light.Light;
	import punk.light.Lighting;
	
	import demos.*;
	import demos.Assets;
	import demos.bloomnblur.*;
	import demos.bloomnblur.bloom.*;
	import demos.bloomnblur.blur.*;
	import demos.gravityemit.*;
	import demos.ogmolevel.*;
	import demos.platformer.*;
	import demos.punkui.*;
	import demos.tinting.*;
	
	/**
	 * ...
	 * @author Time
	 */
	public class LightGame extends World {
		
		private var img:Class = Assets.GFX_LightLVL;
		
		public static var lights:Lighting = new Lighting();
		private var t:Vector.<Light> = new Vector.<Light>();
		
		private var colLerp:Number = 0;
		private var colLerpR:Number = 0.025;
		private var col1:uint;
		private var col2:uint;
		private const blocksTotal:int = 42;
		
		public function LightGame() {
			FP.log("LightGame Started");
			super();
		}
		
		override public function begin():void {
			createLevel();
			addGraphic(new Backdrop(img));
			add(lights);
			super.begin();
			Lighting.updateStaticLights();
		}
		
		override public function update():void {
			
			var heldLights:int = 1;
			
			// Check which Key has been pressed
			if (Input.pressed(Key.X)) {
				Assets.updateWorld(true);
			} else if (Input.pressed(Key.Z)) {
				Assets.updateWorld(false);
			}
			
			if (Input.mouseReleased) {
				if (t.length - heldLights >= 0 && t[t.length - heldLights]) {
					t[t.length - heldLights].dynamicLight = false;
				}
				col1 = FP.getColorRGB(255 * Math.random(), 255 * Math.random(), 255 * Math.random());
				col2 = 0xFFFFFF;
				colLerp = 0;
				colLerpR = Math.abs(colLerpR);
				t.push(new Light(Input.mouseX, Input.mouseY, (Math.random() * 10 + 10) * 15 / Lighting.grid, col1));
				add(t[t.length - 1]);
			}
			for (var i:int = 0; i < Math.min(t.length, heldLights); i++) {
				if (t.length - i >= 0 && t[t.length - 1 - i]) {
					var radius:int = 150;
					t[t.length - 1 - i].x = Input.mouseX + radius * Math.cos(2 * Math.PI * i / Math.min(t.length, heldLights));
					t[t.length - 1 - i].y = Input.mouseY + radius * Math.sin(2 * Math.PI * i / Math.min(t.length, heldLights));
					if (t.length == 1 || heldLights == 1) {
						t[t.length - 1].x = Input.mouseX;
						t[t.length - 1].y = Input.mouseY;
						if (Input.check(Key.SPACE)) {
							colLerp += colLerpR;
							if (colLerp >= 1) {
								colLerpR = -colLerpR;
								colLerp = 1;
							}
							if (colLerp <= 0) {
								colLerpR = -colLerpR;
								colLerp = 0;
							}
							if (t.length > 0 && t[t.length - 1]) {
								t[t.length - 1].color = FP.colorLerp(col1, col2, colLerp);
							}
						}
					}
				}
			}
			super.update();
			
			if (Input.mousePressed) {
				add(new GravityEmitter(Input.mouseX, Input.mouseY));
			}
		}
		
		override public function render():void {
			super.render();
			createLightBox();
		}

		private function createLevel():void {
			// Create Level of blocks
			for (var i:int = 0; i < blocksTotal; i++) {
				var mult:int = 150 / Lighting.grid;
				Lighting.blocks.fillRect(new Rectangle(Math.random() * Lighting.blocks.width, Math.random() * Lighting.blocks.height, Math.ceil(Math.random() * mult), Math.ceil(Math.random() * mult)), 0xFFFFFFFF);
			}
		}
		
		private function createLightBox():void {
			var e:Entity;
			var v:Vector.<Entity> = new Vector.<Entity>();
			getClass(Light, v);
			for each (e in v) {
				Draw.rect(e.x, e.y, Lighting.grid, Lighting.grid, (e as Light).color);
			}
		}
	}
}