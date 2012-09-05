package {
	// Imports
	import net.flashpunk.*;
	
	// Preloader
	[Frame(factoryClass = "Preloader")]
	[SWF(width = "800", height = "600")]

	// Main Engine Window 
		//----> GameWorld
    public class Main extends Engine {

        public function Main() {
            super(800, 600, 60, false);
			
            //FP.world = new Demo();
				// Demo is a PunkUI Test
				
			//FP.world = new BlankWorld();
				// BlankWorld is an Blank world
				
			FP.world = new MainWorld();
				// MainWorld is Cjke's PunkUI Demov2 
				
			//FP.world = new GameWorld();
				// GameWorld is an OgMo Level Test
            return;
        }

        override public function init() : void {
            return;
        }
    }
}
