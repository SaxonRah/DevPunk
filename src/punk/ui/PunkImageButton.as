package punk.ui
{
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import punk.ui.PunkButton;
	import punk.ui.skin.PunkSkin;

	
	/**
	 * ...
	 * @author ...
	 */
	public class PunkImageButton extends PunkButton 
	{
		private var image:Image;
		
		public function PunkImageButton(x:Number=0, y:Number=0, width:int=1, height:int=1, text:String="Button", image:Image = null, onReleased:Function=null, hotkey:int=0, skin:PunkSkin = null, active:Boolean=true) 
		{
			this.image = image;
					
			super(x, y, width, height, text, onReleased, hotkey, skin, active);
		}

		/**
		 * Additional setup steps for this component
		 * @param	skin Skin to use when rendering the component
		 */
		override protected function setupSkin(skin:PunkSkin):void
		{
			if(!skin.punkButton) return;
			
			setUpButtonSkin(skin.punkImageButton);
			
			var labelProperties:Object = skin.punkImageButton.labelProperties;
			if(!labelProperties) labelProperties = new Object;
			labelProperties =  mergeDefault(
			{
				imageAlignHorizontal:"left", 
				imageAlignVertical:"top", 
				align: "center", 
				width: width - image.width, 
				resizable: false, 
				wordWrap: true
			}, labelProperties);
			
			// Setup Image
			image.x = labelProperties.imageAlignHorizontal == "left" ? 0 : width - image.width;
			switch(labelProperties.imageAlignVertical) 
			{
				case "top":
					image.y = 0;
					break;
				case "middle":
					image.y = (height >> 1) - (image.height >> 1);
					break;					
				case "bottom":
					image.y = height - image.height;
					break;
			}			
			
			// Setup Label
			label = new PunkText(textString, labelProperties.imageAlignHorizontal == "left" ? image.width : 0, 0, labelProperties);
			if(!labelProperties.hasOwnProperty("y"))
			{
				label.y = (height >> 1) - (label.textHeight >> 1);
			}
			
		}		
		
		override public function render():void 
		{
			super.render();
			renderGraphic(image);			
		}
		
		
	}

}