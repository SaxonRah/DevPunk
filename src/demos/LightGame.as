package demos
{
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.World;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import flash.geom.Point;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.*;
	import demos.Assets;
	import punk.transition.*;
	import punk.transition.effects.*;
	
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
		
		public function LightGame() {
			super();
			
		}
		
		override public function begin() : void {
			
			
			createLevel();
			addGraphic(new Backdrop(img));
			add(lights);
			super.begin();
			Lighting.updateStaticLights();
		}
		override public function update() : void
		{
			
			var heldLights:int = 1;
			
			// Check which Key has been pressed
			if(Input.released(Key.DIGIT_1))
			{
				Transition.to(Demo, 
					new StarIn({track:"player"}), 
					new StarOut({track:"player"})
				);			
			}
			else if(Input.released(Key.DIGIT_2))
			{
				Transition.to(BlankWorld, 
					new StarIn({color:0xFF06925f, duration:2}), 
					new StarOut({color:0xFF06925f, duration:4})
				);			
			}
			else if(Input.released(Key.DIGIT_3))
			{
				Transition.to(MainWorld, 
					new CircleIn({track:"player"}), 
					new CircleOut({track:"player"})
				);			
			}
			else if(Input.released(Key.DIGIT_4))
			{
				Transition.to(GameWorld, 
					new CircleIn({duration:1, color:0x99993333}), 
					new CircleOut({duration:0.5})
				);							
			}
			else if(Input.released(Key.DIGIT_5))
			{				
				Transition.to(BloomLevel, 
					new FadeIn({duration:4}), 
					new FadeOut({duration:6, color:0xFF334455})
				);			
			}
			else if(Input.released(Key.DIGIT_6))
			{
				Transition.to(BlurLevel, 
					new StripeFadeOut(), 
					new StripeFadeIn()
				);
			}
			else if(Input.released(Key.DIGIT_7))
			{
				Transition.to(BloomNBlur, 
					new BlurOut(), 
					new BlurIn(), 
					{onOutComplete:onBlurOutComplete, onInComplete:onBlurInComplete}
				);
			}			
			else if(Input.released(Key.DIGIT_8))
			{
				Transition.to(WorldOne, 
					new PixelateOut(), 
					new PixelateIn()
				);
			}
			else if(Input.released(Key.DIGIT_9))
			{
				Transition.to(WorldOne, 
					new FlipOut(), 
					new FlipIn()
				);
			}
			else if(Input.released(Key.DIGIT_0))
			{
				Transition.to(TintWorld, 
					new RotoZoomOut(), 
					new RotoZoomIn()
				);
			}
			else if (Input.released(Key.Q)) 
			{
				Transition.to(LightGame, 
					new PixelateOut(), 
					new PixelateIn()
				);
			}
			else if (Input.released(Key.W)) 
			{
				Transition.to(LightGame, 
					new PixelateOut(), 
					new PixelateIn()
				);
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
				add(t[t.length-1]);
			}
			for (var i:int = 0; i < Math.min(t.length, heldLights); i++) {
				if (t.length-i >= 0 && t[t.length-1-i]) {
					var radius:int = 150;
					t[t.length-1-i].x = Input.mouseX + radius * Math.cos(2 * Math.PI * i / Math.min(t.length, heldLights));
					t[t.length - 1 - i].y = Input.mouseY + radius * Math.sin(2 * Math.PI * i / Math.min(t.length, heldLights));
					if (t.length == 1 || heldLights == 1) {
						t[t.length-1].x = Input.mouseX;
						t[t.length - 1].y = Input.mouseY;
						if (Input.check(Key.SPACE)) {
							colLerp += colLerpR;
							if (colLerp >= 1)
							{
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
		
		override public function render() : void {
			super.render();
			createLightBox();
		}
		
		private function onBlurOutComplete() : void {
			trace("Blur Out done!");
		}		
		
		private function onBlurInComplete() : void {
			trace("Blur In done!");
		}
		
		private function createLevel() : void {
			// Create Level of Boxes
			for (var i:int = 0; i < 20; i++) {
				var mult:int = 150 / Lighting.grid;
				Lighting.blockLights.fillRect(new Rectangle(Math.random() * Lighting.blockLights.width, Math.random() * Lighting.blockLights.height, 
					Math.ceil(Math.random() * mult), Math.ceil(Math.random() * mult)), 0xFFFFFFFF);
			}
		}
		
		private function createLightBox() : void {
			var e:Entity;
			var v:Vector.<Entity> = new Vector.<Entity>();
			getClass(Light, v);
			for each(e in v) {
				Draw.rect(e.x, e.y, Lighting.grid, Lighting.grid, (e as Light).color);
			}
		}
	}
}