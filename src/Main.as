package {
	// Imports
	import net.flashpunk.*;
	import demos.*;
	
	// Preloader
	[Frame(factoryClass = "Preloader")]
	[SWF(width = "800", height = "600")]

	// Main Engine Window 
		//----> GameWorld
    public class Main extends Engine {

        public function Main() {
            super(800, 600, 60, false);
			
			// Start on Any of the worlds 
			/*
			 * Demo 
			 * BlankWorld
			 * MainWorld
			 * GameWorld
			 * BloomWorld
			 * BlurWorld
			 * BloomNBlur
			 * WorldOne
			 * WorldTwo
			 */
			FP.world = new WorldOne();
				
			FP.console.enable();
            return;
        }

        override public function init() : void {
            return;
        }
    }
}
