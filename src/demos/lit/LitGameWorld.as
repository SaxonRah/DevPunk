package  demos.lit
{
	import punk.lit.Light;
	import punk.lit.Lighting;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	import demos.Assets;
	
	/**
	 * ...
	 * @author alex larioza
	 */
	public class LitGameWorld extends World 
	{

		public var lighting:Lighting;
		public var mouseLight:Light;
		
		public function LitGameWorld() 
		{
			
		}
		
		override public function begin():void 
		{
			super.begin();
			
			// background image
			var bg:Backdrop = new Backdrop(Assets.SPR_BACKGROUND);
			this.addGraphic(bg, 1000);
			
			// create new lighting
			add(lighting = new Lighting(FP.screen.width, FP.screen.height));
			
			// add lights
			for (var i:uint = 0; i < 50; i++)
			{
				var image:Image = new Image(FP.choose(Assets.SPR_LIGHT_SQUARE, Assets.SPR_LIGHT_CIRCLE, Assets.SPR_LIGHT_CIRCLE_GRADIENT));
				image.centerOO();
				lighting.add(new Light(FP.rand(FP.screen.width), FP.rand(FP.screen.height), image, Math.random() * 1.5 + 0.5, Math.random(), Math.random() * 100 * FP.elapsed));
			}
			
			// add light that follows mouse
			image = new Image(Assets.SPR_LIGHT_CIRCLE);
			image.centerOO();
			mouseLight = new Light(0, 0, image, 4, 0.8);
			lighting.add(mouseLight);
			
			// info
			var text:Text = new Text("WSAD: move camera\nR: restart world\nMOUSE: move mouse light")
			addGraphic(text, -1000, 0, 32)
		}
		
		override public function update():void 
		{
			super.update();
			
			// Check which Key has been pressed
			if(Input.pressed(Key.X)) {
				Assets.updateWorld(true);
			} else if (Input.pressed(Key.Z)) {
				Assets.updateWorld(false);
			}
			
			mouseLight.x = mouseX;
			mouseLight.y = mouseY;
			
			if (Input.pressed(Key.R))
			{
				FP.world = new LitGameWorld()
			}
			
			if (Input.check(Key.D))
			{
				camera.x += 100 * FP.elapsed;
			}
			if (Input.check(Key.A))
			{
				camera.x -= 100 * FP.elapsed;
			}
			if (Input.check(Key.S))
			{
				camera.y += 100 * FP.elapsed;
			}
			if (Input.check(Key.W))
			{
				camera.y -= 100 * FP.elapsed;
			}
		}
		
	}

}