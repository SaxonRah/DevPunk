package demos {
	
	import flash.display.BitmapData;
    import flash.geom.*;
	import flash.system.System;
	import flash.net.LocalConnection;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import punk.transition.*;
	import punk.transition.effects.*;

	import demos.*;
	import demos.Assets;
	import demos.bloomnblur.*;
	import demos.bloomnblur.bloom.*;
	import demos.bloomnblur.blur.*;
	import demos.gravityemit.*;
	import demos.lighting.*;
	import demos.ogmolevel.*;
	import demos.platformer.*;
	import demos.punkui.*;
	import demos.tinting.*;
	import demos.tilelighting.LightWorld;
	
    public class Assets extends Object {
		
		// PunkUI stuff
		[Embed(source = "../../assets/34x34icons.png")] public static var icons:Class;
        public static var flail:Spritemap = new Spritemap(icons, 34, 34);
        public static var sword:Spritemap = new Spritemap(icons, 34, 34);
        public static var wand:Spritemap = new Spritemap(icons, 34, 34);
        public static var down:Spritemap = new Spritemap(icons, 34, 34);
		
		// Ogmo levels
		[Embed(source = "../../assets/examplelevel.oel", mimeType = "application/octet-stream")]
		public static const LVL_SAMPLE:Class;

		// gfx for PunkUIDemo
		[Embed(source = "../../assets/lofi_environment.png")]
		public static const SPR_TILES:Class;
		[Embed(source = "../../assets/coin.png")]
		public static const SPR_COIN:Class;
		[Embed(source = "../../assets/player.png")]
		public static const SPR_PLAYER:Class;
		
		// Lighting
		[Embed(source = "../../assets/back.png")]
		public static const GFX_LightLVL:Class;
		[Embed(source = "../../assets/light.png")]
		public static const GFX_Light:Class;
		
		//tile Lighting
		[Embed(source = "../../assets/lighting.png")]
		public static const SPR_LIGHTING:Class;
		[Embed(source = "../../assets/bg.png")]
		public static const SPR_BG:Class;
		
		// Platformer gfx
		[Embed(source="../../assets/map1.png")]
		public static const GFX_MAP:Class;
		[Embed(source = '../../assets/swordguy.png')]
		public static const SWORDGUY:Class;
		
		// Global Level Switching
		public static var worldNumber:int = 0;
		public static const numberOfWorlds:int = 10;
		
		// devPunk - Hack to collect memory
		public static function gcHackLog(imm:Number):void {
			try {
				FP.gcHack(imm)
			} catch (e:*) { }
			FP.log("End gcHack");
		}
		
		public static function updateWorld(_increment:Boolean = true) : void {
			if(_increment) {
				if(worldNumber < numberOfWorlds) worldNumber++;
			}
			else {
			if(worldNumber > 0) worldNumber--;
			}
		
			//Transition code here for next/previous world.
			//Example, a switch.
			switch(worldNumber) {
			case 0:
					FP.world = new LightGame();
				break;
			case 1:
					gcHackLog(0.25);
					Transition.to(GameWorld,
					new CircleIn({duration:1, color:0x99993333}),
					new CircleOut({duration:1, color:0x99993333}));
				break;
			case 2:
					gcHackLog(0.25);
					Transition.to(BloomLevel,
					new FadeIn({duration:4}),
					new FadeOut({duration:6, color:0xFF334455}));
				break;
			case 3:
					
					gcHackLog(0.25);
					Transition.to(BlurLevel,
					new StripeFadeOut(),
					new StripeFadeIn());
					
				break;
			case 4:
					gcHackLog(0.25);
					Transition.to(BloomNBlur,
					new BlurOut(),
					new BlurIn());
				break;
			case 5:
					gcHackLog(0.25);
					Transition.to(WorldOne,
					new StarIn({track:"player"}), 
					new StarOut({track:"player"}));	
				break;
			//case 6:
			//		gcHackLog(0.25);
			//		Transition.to(Demo,
			//		new StarIn({color:0xFF06925f, duration:2}),
			//		new StarOut({color:0xFF06925f, duration:4}));	
			//	break;
			//case 7:
			//		gcHackLog(0.25);
			//		Transition.to(BlankWorld,
			//		new StripeFadeOut(),
			//		new StripeFadeIn());
			//	break;
			//case 8:
			//		gcHackLog(0.25);
			//		Transition.to(MainWorld,
			//		new CircleIn(),
			//		new CircleOut());
			//	break;
			case 6:
					gcHackLog(0.25);
					Transition.to(TintWorld,
					new RotoZoomOut(),
					new RotoZoomIn());
				break;
			case 7:
					gcHackLog(0.25);
					Transition.to(LightWorld,
					new RotoZoomOut(),
					new RotoZoomIn());
				break;
			}
		}
	}
}