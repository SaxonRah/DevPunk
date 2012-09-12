package demos
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author Time
	 */
	public class Light extends Entity
	{
		private var _dynamicLight:Boolean;
		public var range:int;
		private var myLight:BitmapData;
		private var pixel:BitmapData;
		private var pos:Matrix;
		
		private var maximumPenetration:int = 4;
		//Picks out a random color for the light.
		public var color:uint;		
		/**
		 * Constructor
		 * @param	_x				x position.
		 * @param	_y				y position.
		 * @param	_r				range of the light.
		 * @param	_c				color of the light.
		 * @param	t_dynamicLight	whether the light is dynamic or not.
		 */
		public function Light(_x:int, _y:int, _r:int, _c:uint = 0xFFFFFF, t_dynamicLight:Boolean=true) 
		{
			super(_x, _y);
			
			range = _r;
			color = _c;
			dynamicLight = t_dynamicLight;
		}
		
		override public function update():void
		{
			x = Math.floor(x / Lighting.grid) * Lighting.grid;
			y = Math.floor(y / Lighting.grid) * Lighting.grid;
		}
		
		public function updateLight():void
		{
			initializeLight(range);
		}
		
		/**
		 * Draws the light using raycasting to the appropriate buffer in the Lighting object.
		 * @param	_r		the range of the light.
		 */
		public function initializeLight(_r:int):void
		{
			if (_r <= 0)
			{
				return;
			}
			var i:Number;
			var j:int;
			//Set up variables like my light buffer, my position matrix, and a temporary pixel bitmapdata.
			myLight = new BitmapData(_r * 2, _r * 2, true, 0x00000000);
			pos = new Matrix(1, 0, 0, 1, Math.ceil(x / Lighting.grid - _r), Math.ceil(y / Lighting.grid - _r));
			pixel = new BitmapData(1, 1, true, 0x00000000);
			
			//This finishedPixels object will keep track of pixels that have already been checked.
			//This will allow the program to skip over those pixels instead of redrawing them.
			var finishedPixels:Object = new Object();
			for (i = 0; i < myLight.width; i++)
			{
				finishedPixels[i] = new Object();
			}
			for (i=0; i < 2 * Math.PI; i+=2*Math.PI/Math.pow(_r, 1.5)/3)
			{
				//This variable darkens the ray of light if it hits something.
				//This lets the light penetrate a bit as it goes into the blocks and gives a nice effect.
				var _darkener:int = 1;
				for (j=1; j < _r; j++)
				{
					var t_x:int = _r + j * Math.cos(i);
					var t_y:int = _r + j * Math.sin(i);
					//If the pixel has already been defined, then just check if it's blocked to add to
					//the _darkener value, then go to the next pixel.
					if (finishedPixels[t_x][t_y])
					{
						if (Lighting.blockLights.getPixel32(pos.tx + t_x, pos.ty + t_y) != 0x00000000)
						{
							_darkener++;
							if (_darkener > maximumPenetration)
							{
								break;
							}
						}
						continue;
					}
					//Confirm that we've checked this pixel.
					finishedPixels[t_x][t_y] = true;
					//This _m variable calculates the alpha value for the given pixel to draw.
					var _m:Number = (1 - j / _r) * (1 - _darkener / (maximumPenetration+1));
					var _c:uint = FP.getColorARGB(255 * _m, FP.getRed(color), FP.getGreen(color), FP.getBlue(color));
									
					if (!changePixel(t_x, t_y, _c)) 
					{ 
						_darkener++; 
						if (maximumPenetration == 0) 
						{
							break; 
						}
					}
					
					//After the beam has hit maximumPenetration obstacles, it will stop raycasting.
					if (_darkener > maximumPenetration)
					{
						break;
					}
				}
			}
			//Clean up the pixel bitmapdata we made earlier.
			pixel.dispose();
			//Draw my buffer to the main Lighting buffer with a blend mode
			if (dynamicLight)
			{
				Lighting.dynamicLights.draw(myLight, pos, null, BlendMode.LIGHTEN);
			}
			else 
			{
				Lighting.staticLights.draw(myLight, pos, null, BlendMode.LIGHTEN);
			}
			//Get rid of my buffer until it's needed later.
			myLight.dispose();
		}
		
		/**
		 * Changes a pixel at a position to a color, taking into account the brightness of the current color.
		 * @param	t_x		The x position to change.
		 * @param	t_y		The y position to change.
		 * @param	_c		The color to change.
		 * @return	A boolean for whether the position was blocked or not.
		 */
		public function changePixel(t_x:int, t_y:int, _c:uint):Boolean
		{
			var checkCase:Boolean = Lighting.blockLights.getPixel32(pos.tx + t_x, pos.ty + t_y) == 0x00000000;
			
			//Fills the pixel bitmapdata with the appropriate color.
			pixel.fillRect(pixel.rect, _c);
			//...Then draws that to the light's buffer.
			myLight.copyPixels(pixel, pixel.rect, new Point(t_x - Math.floor(pixel.width/2), t_y - Math.floor(pixel.height/2)));
			
			//If the positions is not blocked, return true.
			if (checkCase)
			{
				return true;
			}
			return false;
		}
		
		public function set dynamicLight(_d:Boolean):void
		{
			_dynamicLight = _d;
			
			//When the light is changed from dynamic to static and back, it needs to do an update (mostly for d -> s)
			updateLight();
		}
		
		public function get dynamicLight():Boolean
		{
			return _dynamicLight;
		}
		
	}

}