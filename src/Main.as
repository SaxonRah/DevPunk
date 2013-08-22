package {
	// Imports
	import demos.box2d.B2DWorld;
	import demos.punkfx.TestWorld;
	import net.flashpunk.*;
	import demos.lighting.*;
	import splash.Splash;
	
	import demos.box2d.B2DWorld;
	
	import punk.box2fp.Box2DWorld;
	
	// Preloader
	[Frame(factoryClass="Preloader")]
	[SWF(width="800",height="600",framerate="60")]
	
	//----> s.start(new AnyDemoWorldNameHere);
	public class Main extends Engine {
		
		public function Main() {
			super(800, 600, Box2DWorld.DEFAULT_FRAMERATE, false);
			FP.console.enable();
			var s:Splash = new Splash();
			FP.world.add(s);
			FP.log("Started Logo");
			s.start(new LightGame);
			//FP.world = new B2DWorld();
		}
	}
}