package punk.ui
{
	import net.flashpunk.graphics.*;
	import punk.ui.*;
	import punk.ui.skin.PunkSkin;
	import punk.ui.skin.PunkSkinImage;
	import punk.ui.skins.*;
	
	/**
	 * ...
	 * @author cjke7777
	 * 
	 * http://www.pixeljoint.com/pixelart/37532.htm
	 * Added some stuff!!
	 */
	public class PunkCombo extends PunkPanel 
	{
		private var options:Vector.<PunkComboOption> = new Vector.<PunkComboOption>();
		private var _opened:Boolean = false;
		private var _onReleased:Function = null;
		private var _downButton:PunkImageButton;
		private var _background:PunkBackground;
		
		public function PunkCombo(x:Number = 0, y:Number = 0, width:Number = 224, height:Number = 24, options:Array = null, onReleased:Function = null, skin:PunkSkin = null) 
		{
			super(x, y, width, (height * options.length) + height + 9, skin);
			
			_onReleased = onReleased;
			
			_background = new PunkBackground(0, height, width, (options.length * height)+9, skin);
			add(_background);
			
			
			if ( ! options) options = [""];
			
			for (var i:int = 0; i < options.length; i++)
			{
				var option:PunkComboOption = new PunkComboOption(5, (i * height) + height +4, width - 10, height, options[i], onComboRelease, i, skin);
				option.label.align = "left";
				option.label.x = 10;
				add(option);
				this.options.push(option);
			}
			

			_downButton = new PunkImageButton(0, 0, width, height, options[0], Assets.down, onDownClick);
			add(_downButton);
			
			close();
			
			
		}
		
		private function onDownClick():void 
		{
			if(_opened) 
			{
				close();
			}
			else
			{
				open();
			}
		}
		
		public function get opened():Boolean 
		{
			return _opened;
		}
		
		public function open():void 
		{			
			_opened = true;
			var i:int;
			var l:int = options.length;
			for(i = 0; i < l; i++)
			{
				options[i].visible = true;
			}			
			_background.visible = true;
		}
		
		public function close():void 
		{			
			_opened = false;
			var i:int;
			var l:int = options.length;
			for(i = 0; i < l; i++)
			{
				options[i].visible = false;
			}			
			_background.visible = false;
		}		
		
		private function onComboRelease(index:int):void 
		{		
			close();
			_downButton.label.text = options[index].label.text;
			if(_onReleased !== null) 
			{
				_onReleased(index);
			}
		}	
		
	}

}