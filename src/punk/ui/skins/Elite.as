package punk.ui.skins
{
	import flash.display.*;
	import flash.geom.*;
	import net.flashpunk.*;
	import punk.ui.skin.*;
		
	
	/**
	 * Elite skin definition
	 */		
	public class Elite extends PunkSkin
	{
		/**
		 * The asset to use for the skin image. 
		 */		
		[Embed(source="elite.gif")] 
		private const I:Class;
		
		/**
		 * Constructor. 
		 */		
		public function Elite()
		{
			super();			
			
			punkButton = new PunkSkinButtonElement
			(
				gy(0, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2), 
				gy(40, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2), 
				{color: 0x000000, size: 16}
			);
			
			punkImageButton = new PunkSkinButtonElement
			(
				gy(0, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2), 
				gy(40, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2), 
				{
					color: 0x000000, size: 16,
					imageAlignHorizontal:"left",					
					imageAlignVertical:"middle"				
				}
			);		
			
	

			punkToggleButton = new PunkSkinToggleButtonElement
			(
				gy(0, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2), 
				gy(20, 0, 20, 20, 2,2,2,2),
				{color: 0x000000, size: 16, align: "center"}
			);
			
			punkRadioButton = new PunkSkinToggleButtonElement
			(
				gn(0, 40), 
				gn(20, 40), 
				gn(40, 40), 
				gn(20, 40),
				gn(0, 59),
				gn(20, 59), 
				gn(40, 59), 
				gn(20, 59), 
				{color: 0x000000, size: 16, x: 22}
			);	
			
			 /*punkBackground = new PunkSkinBackgroundElement(
				gy(20, 80, 20, 20, 4, 4, 4, 4)
			)*/
			
			punkLabel = new PunkSkinHasLabelElement({color: 0x000000, size: 16});
			punkTextArea = new PunkSkinLabelElement({color: 0xFBFFD9, size: 16, x: 5, y: 5, selectable:false}, gy(40, 80, 20, 20, 4, 4, 5, 4));
			punkTextField = new PunkSkinLabelElement({color: 0x000000, size: 16, x: 4}, gy(40, 80, 20, 20));
			punkPasswordField = new PunkSkinLabelElement({color: 0x000000, size: 16, x: 4}, gy(40, 80, 20, 20));
			
			punkWindow = new PunkSkinWindowElement
			(
				gy(00, 80, 20, 20, 4, 4, 4, 4), 
				gy(20, 80, 20, 20, 4, 4, 4, 4), 
				{color: 0XFBFFD9, size: 16, x: 3, y: 1} 
			);
			
			punkSlider = new PunkSkinSliderElement
			(
				gy(00, 00, 20, 20, 2,2,2,2), 
				gy(20, 00, 20, 20, 2,2,2,2), 
				gy(00, 00, 20, 20, 2,2,2,2), 
				gy(20, 00, 20, 20, 2,2,2,2), 
				gy(00, 00, 20, 20, 2,2,2,2),
				gy(20, 00, 20, 20, 2,2,2,2)
			);
		}
		
		/**
		 * Returns the portion of the skin image as a PunkSkinImage object in a 9-Slice format
		 * @param	x X-Coordinate for the image offset
		 * @param	y Y-Coordinate for the image offset
		 * @param	w Width of the image sub-section
		 * @param	h Height of the image sub-section
		 * @return PunkSkinImage for the image sub-section requested in 9-Slice format
		 */
		protected function gy(x:int, y:int, w:int=20, h:int=20, leftWidth:int = 1, rightWidth:int = 1, topHeight:int = 1, bottomHeight:int = 1):PunkSkinImage
		{
			return new PunkSkinImage(gi(x, y, w, h), true, leftWidth, rightWidth, topHeight, bottomHeight);
		}
		
		/**
		 * Returns the portion of the skin image as a PunkSkinImage object in a non 9-Sliced format
		 * @param	x X-Coordinate for the image offset
		 * @param	y Y-Coordinate for the image offset
		 * @param	w Width of the image sub-section
		 * @param	h Height of the image sub-section
		 * @return PunkSkinImage for the image sub-section requested in a non 9-Sliced format
		 */
		protected function gn(x:int, y:int, w:int=20, h:int=20):PunkSkinImage
		{
			return new PunkSkinImage(gi(x, y, w, h), false);
		}
		
		/**
		 * Returns the portion of the skin image requested as a BitmapData object
		 * @param	x X-Coordinate for the image offset
		 * @param	y Y-Coordinate for the image offset
		 * @param	w Width of the image sub-section
		 * @param	h Height of the image sub-section
		 * @return BitmapData for the image sub-section requested
		 */
		protected function gi(x:int, y:int, w:int=20, h:int=20):BitmapData
		{
			_r.x = x;
			_r.y = y;
			_r.width = w;
			_r.height = h;
			
			var b:BitmapData = new BitmapData(w, h, true, 0);
			b.copyPixels(FP.getBitmap(I), _r, FP.zero, null, null, true);
			return b;
		}
		
		private var _r:Rectangle = new Rectangle;		
	}
}