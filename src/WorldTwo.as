package  
{
	import flash.display.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import punk.transition.*;
	import punk.transition.effects.*;
	
	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com
	 */	
	public class WorldTwo extends World 
	{
		[Embed(source="../assets/map2.png")]
		private var GFX_MAP:Class;
		
		private var _player:SidePlayer;
		
		public function WorldTwo() 
		{
			FP.log("World Two Started");			
			
			var img:Image = new Image(GFX_MAP);
			img.scale = 2;
			addGraphic(img);
			
			_player = new SidePlayer(200, 130);
			add(_player);
		}
		
		override public function update():void 
		{
			// Check which Key has been pressed
			if(Input.released(Key.DIGIT_1))
			{
				Transition.to(WorldOne, 
					new StarIn({track:"player"}), 
					new StarOut({track:"player"})
				);			
			}
			else if(Input.released(Key.DIGIT_2))
			{
				Transition.to(WorldOne, 
					new StarIn({color:0xFF06925f, duration:2}), 
					new StarOut({color:0xFF06925f, duration:4})
				);			
			}
			else if(Input.released(Key.DIGIT_3))
			{
				Transition.to(WorldOne, 
					new CircleIn({track:"player"}), 
					new CircleOut({track:"player"})
				);			
			}
			else if(Input.released(Key.DIGIT_4))
			{
				Transition.to(WorldOne, 
					new CircleIn({duration:1, color:0x99993333}), 
					new CircleOut({duration:0.5})
				);							
			}
			else if(Input.released(Key.DIGIT_5))
			{				
				Transition.to(WorldOne, 
					new FadeIn({duration:4}), 
					new FadeOut({duration:6, color:0xFF334455})
				);			
			}
			else if(Input.released(Key.DIGIT_6))
			{
				Transition.to(WorldOne, 
					new StripeFadeOut(), 
					new StripeFadeIn()
				);
			}
			else if(Input.released(Key.DIGIT_7))
			{
				Transition.to(null, 
					new BlurOut(), 
					new BlurIn(), 
					{onOutComplete:onBlurOutComplete, onInComplete:onBlurInComplete}
				);
			}			
			else if(Input.released(Key.DIGIT_8))
			{
				Transition.to(WorldOne, 
					new PixelateOut(), 
					new PixelateIn()
				);
			}
			else if(Input.released(Key.DIGIT_9))
			{
				Transition.to(WorldOne, 
					new FlipOut(), 
					new FlipIn()
				);
			}
			else if(Input.released(Key.DIGIT_0))
			{
				Transition.to(WorldOne, 
					new RotoZoomOut(), 
					new RotoZoomIn()
				);
			}
			
			super.update();
					
			FP.camera.x = _player.x - FP.halfWidth;
			FP.camera.y = _player.y - FP.halfHeight;
			FP.clampInRect(FP.camera, 0, 0, 1024 - FP.width, 512 - FP.height);				
		}
		
		private function onBlurOutComplete():void 
		{
			trace("Blur Out done!");
		}		
		
		private function onBlurInComplete():void 
		{
			trace("Blur In done!");
		}
		
		public function get player():Entity 
		{
			return _player;
		}
		
	}

}