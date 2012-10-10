package {
	// Imports
	import net.flashpunk.*;
	import demos.*;
	import demos.ogmolevel.GameWorld;
	import demos.lighting.*;
	import splash.Splash;
	
	// Preloader
	[Frame(factoryClass = "Preloader")]
	[SWF(width = "800", height = "600")]

	//----> s.start(new AnyDemoWorldNameHere);
    public class Main extends Engine {
		
        public function Main() {
            super(800, 600, 60, false);
			FP.console.enable();
			var s:Splash = new Splash();
			FP.world.add(s);
			FP.log("Started Logo");
			s.start(new LightGame);
		}
    }
}