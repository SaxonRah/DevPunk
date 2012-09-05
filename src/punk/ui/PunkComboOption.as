package punk.ui
{
	import punk.ui.PunkButton;
	import punk.ui.PunkText;
	import punk.ui.PunkUIComponent;
	import punk.ui.skin.PunkSkin;
	import punk.ui.skin.PunkSkinButtonElement;
	/**
	 * ...
	 * @author ...
	 */
	public class PunkComboOption extends PunkButton
	{
		private var _index:int;
		private var _onReleased:Function;
		
		public function PunkComboOption(x:Number = 0, y:Number = 0, width:int = 1, height:int = 1, text:String = "Button", onReleased:Function = null, index:int = 0, skin:PunkSkin = null) 
		{
			_onReleased = onReleased;
			_index = index;
			
			super(x, y, width, height, text, null, 0, skin, true);
		}
		
		/**
		 * Additional setup steps for this component
		 * @param	skin Skin to use when rendering the component
		 */


		override protected function releasedCallback():void
		{
			isPressed = false;
			if(_onReleased != null) _onReleased(_index);
		}
		
	}

}