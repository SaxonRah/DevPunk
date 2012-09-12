package demos {
	import flash.display.BitmapData;
    import flash.geom.*;
    import net.flashpunk.graphics.*;
	
    public class Assets extends Object {
		[Embed(source = "../../assets/34x34icons.png")] public static var icons:Class;
        public static var flail:Spritemap = new Spritemap(icons, 34, 34);
        public static var sword:Spritemap = new Spritemap(icons, 34, 34);
        public static var wand:Spritemap = new Spritemap(icons, 34, 34);
        public static var down:Spritemap = new Spritemap(icons, 34, 34);
		
		// levels
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
		
        public function Assets() {
            return;
        }// end function

    }
}
