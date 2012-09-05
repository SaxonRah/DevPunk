package punk.ui 
{
	import punk.ui.skin.PunkSkin;
	/**
	 * ...
	 * @author Erifdex
	 */
	public class PunkOptionButton
	{
		public var punkbutton : PunkButton;
		
		/**
		 * Used with a PunkOptionWindow to set desired buttons.
		 * @param	text The button's label
		 * @param	onReleased Function to call when the button is pressed.
		 * @param	hotkey Hotkey. (Key.SPACE etc..)
		 * @param	skin The button's PunkSkin.
		 */
		public function PunkOptionButton(text : String = "Ok", onReleased : Function = null, hotkey : int = 0, skin : PunkSkin = null) 
		{
			punkbutton = new PunkButton(0, 0, 1, 1, text, onReleased, hotkey, skin);
		}
	}
}