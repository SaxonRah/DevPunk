package punk.ui {
	import punk.ui.skin.PunkSkin;
	/**
	 * @author Erifdex
	 */
	public class PunkOptionWindow extends PunkWindow {
	
		//some variables
		private var mainCaption:String;
		private var optionbuttons:Array;
		private var punkbuttons:Array = new Array();
		private var buttonWidth : Number;
		private var xPos : Number = 4;
		
		//static variables
		public static var wW : Number = 320;
		public static var wH : Number = 120;

		/**
		 * Creates a new PunkOptionWindow with desired buttons.
		 * @param	x X position.
		 * @param	y Y position.
		 * @param	menuBarCaption The caption for the top bar.
		 * @param	mainCaption The caption for the body.
		 * @param	draggable Whether the component can be dragged by the user using the mouse.
		 * @param	buttons An array of PunkOptionButtons, for the buttons.
		 */
		public function PunkOptionWindow(x:Number, 
						y:Number,
						wW:Number,
						wH:Number,
						menuBarCaption : String = "!", 
						mainCaption : String = "...", 
						draggable : Boolean = true,
						buttons : Array = null
						) 
		{
			super(x, y, wW, wH, menuBarCaption, draggable);
			optionbuttons = buttons;
			this.mainCaption = mainCaption;
			
			buttonWidth = (wW / optionbuttons.length) - ((xPos *2) / optionbuttons.length);
			
			initButtons();
			initCaption();
		}
		
		//sets up the buttons.
		private function initButtons():void 
		{		
			
			
			for each (var item:PunkOptionButton in optionbuttons) 
			{				
				var b : PunkButton = new PunkButton(xPos, wH - 44, buttonWidth, wH / 3, item.punkbutton.label.text, item.punkbutton.onReleased, item.punkbutton.hotkey);
				punkbuttons.push(b);
				
				xPos += buttonWidth;
			}
			
			for each (var pb: PunkButton in punkbuttons) 
			{
				this.add(pb);
			}
		}
		
		//sets up the caption.
		private function initCaption():void 
		{			
			var c : PunkLabel = new PunkLabel(mainCaption, 4, 16, wW - 8, 32);
			add(c);
		}
		
		/**
		 * Closes the window.
		 */
		public function close():void
		{
			world.remove(this);
		}
	}
}