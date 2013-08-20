package  punk.lit
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Noel Berry
	 */
	public class Lighting extends Entity
	{	
		
		private var _fillColor:int;
		/**
		 * The fill color of the canvas
		 */
		public function get fillColor():int { return _fillColor; }
		public function set fillColor(value:int):void { _fillColor = value; }
		
		/**
		 * Creates a new lighting object
		 * @param	width	width of the lighting canvas
		 * @param	height	hight of the lighting canvas
		 * @param	fillColor	fill color
		 * @param	layer	layer to place the lighting on (usually above everything else)
		 */
		public function Lighting(width:int, height:int, fillColor:int = 0xFFFFFF, layer:int = -1000) 
		{
			super();
			
			this.layer = layer;
			_fillColor = fillColor;
			_canvas = new BitmapData(width, height, false, fillColor);
		}
		
		/**
		 * Adds a new light to the system
		 * @param	light	the light object to add
		 */
		public function add(light:Light):void
		{
			_lights[_lights.length] = light;
		}
		
		/**
		 * Removes a light from the system
		 * @param	light	the light to remove
		 */
		public function remove(light:Light):void
		{
			var i:int = _lights.indexOf(light)
			_lights.splice(i, 1);
		}
		
		/**
		 * Removes all the lights from the system
		 */
		public function clear():void
		{
			_lights.length = 0
		}
		
		/**
		 * Renders all the lights to the screen
		 */
		override public function render():void 
		{
			super.render();
			
			// redraw the canvas
			_canvas.fillRect(_canvas.rect, _fillColor);
			
			// go through each light and render it to the canvas
			for each (var light:Light in _lights)
			{
				// if this light is not active, skip it
				if (!light.active) { continue; }
				
				// if not on camera, don't render
				if (light.x < world.camera.x - light.image.width || light.x > world.camera.x + light.image.width + FP.screen.width 
				|| light.y < world.camera.y - light.image.height || light.y > world.camera.y + light.image.height + FP.screen.height) { continue; }
				
				// rotate the image (if enabled)
				(light.image.angle + light.rotate < 360) ? light.image.angle += light.rotate : light.image.angle = 0;
				// scale
				light.image.scale = light.scale;
				// alpha
				light.image.alpha = light.alpha;
				
				// render the light to the canvas
				_renderTo.x = light.x;
				_renderTo.y = light.y;
				light.image.render(_canvas, _renderTo, FP.camera);
			}
			
			// render the canvas to the screen
			FP.buffer.draw(_canvas, null, _colorTransform, BlendMode.SUBTRACT);
		}
				
		/** @private **/ internal var _renderTo:Point = new Point(0, 0);
		/** @private **/ internal var _canvas:BitmapData;
		/** @private **/ internal var _colorTransform:ColorTransform = new ColorTransform(1, 1, 1, 1);
		/** @private **/ internal var _lights:Vector.<Light> = new Vector.<Light>();
	}

}