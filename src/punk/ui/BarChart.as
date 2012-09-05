package punk.ui 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import punk.ui.skin.PunkSkin;
	/**
	 * ...
	 * @author cjke.7777@gmail.com
	 */
	public class BarChart extends PunkWindow 
	{
		public var data:Array = [];
		protected var canvas:Canvas;
				
		protected var maxY:Number = 1000;
		protected var canvasHeight:Number;
		protected var canvasWidth:Number;
		protected var barWidth:Number = 2;
		protected var barSpacing:Number = 1;
		protected var color:uint = 0xffaf37;
		protected var padding:Number = 5;
		protected var dataChanged:Boolean = false;
		
		public function BarChart(x:Number=0, y:Number=0, width:int=20, height:int=20, caption:String = "", data:Array = null, draggable:Boolean = true, skin:PunkSkin=null) 
		{
			super(x, y, width, height, caption, draggable, skin);
			
			this.data = data == null ? [] : data;
			dataChanged = true;
			canvasHeight = height - barHeight - padding - padding;
			canvasWidth = width - padding - padding;
			canvas = new Canvas(canvasWidth, canvasHeight);
			canvas.x = padding;			
			canvas.y = padding;	

		}
		
		override protected function setupSkin(skin:PunkSkin):void
		{
			super.setupSkin(skin);			
			
			
		}

		override public function update():void
		{
			super.update();
		}
		
		private var i:int;
		private var l:int;		
		
		override public function render():void
		{
			super.render();

			if(true)//dataChanged
			{

				dataChanged = false; 
				
				// Clear
				canvas.fill(new Rectangle(0, 0, canvasWidth, canvasHeight), 0, 0);				

				var p:Number; // percent of height
				for(i = 0; i < data.length; i++)
				{
					p = 1 - (data[i] / maxY); // inverted percentage
					canvas.drawRect(new Rectangle((i * barWidth) + (i * barSpacing), p * canvasHeight, barWidth, canvasHeight - (p * canvasHeight)), color, 1);
				}
			}
			renderGraphic(canvas);
		}
		
	}

}