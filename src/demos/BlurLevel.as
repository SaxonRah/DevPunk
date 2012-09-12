package demos 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import punk.transition.*;
	import punk.transition.effects.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Reiss
	 */
	public class BlurLevel extends World
	{
		/* time between particle creation */
		public static const MIN_LAPSED_CREATE_TIME:Number = 0.05;
		public static const MAX_ADDITIONAL_CREATE_TIME:Number = 0.025;
		
		/* amount of motion blur desired */
		private static const BLUR:Number = 0.8;
		
		/* particle timing */
		private var _elapsed:Number = 0.0;
		private var _timeToNextParticle:Number = calcNextParticleTime();
		
		/* motion blur */
		private var _blur:BlurCanvas = new BlurCanvas(BLUR);
		
		public function BlurLevel() {
		FP.log("Blur World Started");	
		}
		
		override public function begin():void
		{
			
			//set the blur to be under the particles, and add it to the world
			_blur.layer = 1;
			add(_blur);
			
			//create an initial particle
			(create(BlurParticle) as BlurParticle).blur(_blur);
			
			//add some text -- don't bother wrapping it in a BlurWrapper, since it doesn't move
			var txt:Entity = new Entity();
			var img:Text;
			Text.size = 48;
			txt.graphic = img = new Text("BlurPunk");
			txt.x = FP.width / 2 - img.width / 2;
			txt.y = FP.height / 2 - img.height / 2;
			img.outlineStrength = 10;
			img.outlineColor = 0xFF34B3;
			img.updateTextBuffer();
			add(txt);
		}
		
		override public function update():void
		{
			// Check which Key has been pressed
			if(Input.released(Key.DIGIT_1))
			{
				Transition.to(Demo, 
					new StarIn({track:"player"}), 
					new StarOut({track:"player"})
				);			
			}
			else if(Input.released(Key.DIGIT_2))
			{
				Transition.to(BlankWorld, 
					new StarIn({color:0xFF06925f, duration:2}), 
					new StarOut({color:0xFF06925f, duration:4})
				);			
			}
			else if(Input.released(Key.DIGIT_3))
			{
				Transition.to(MainWorld, 
					new CircleIn({track:"player"}), 
					new CircleOut({track:"player"})
				);			
			}
			else if(Input.released(Key.DIGIT_4))
			{
				Transition.to(GameWorld, 
					new CircleIn({duration:1, color:0x99993333}), 
					new CircleOut({duration:0.5})
				);							
			}
			else if(Input.released(Key.DIGIT_5))
			{				
				Transition.to(BloomLevel, 
					new FadeIn({duration:4}), 
					new FadeOut({duration:6, color:0xFF334455})
				);			
			}
			else if(Input.released(Key.DIGIT_6))
			{
				Transition.to(BlurLevel, 
					new StripeFadeOut(), 
					new StripeFadeIn()
				);
			}
			else if(Input.released(Key.DIGIT_7))
			{
				Transition.to(BloomNBlur, 
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
				Transition.to(TintWorld, 
					new RotoZoomOut(), 
					new RotoZoomIn()
				);
			}
			else if (Input.released(Key.Q)) 
			{
				Transition.to(LightGame, 
					new PixelateOut(), 
					new PixelateIn()
				);
			}
			else if (Input.released(Key.W)) 
			{
				Transition.to(LightGame, 
					new PixelateOut(), 
					new PixelateIn()
				);
			}
			
			
			super.update();
	
			if (Input.mousePressed) {
				add(new GravityEmitter(Input.mouseX, Input.mouseY));
			}
		
			/* spawn new particles if enough time has passed */
			if (_elapsed >= _timeToNextParticle)
			{
				_elapsed -= _timeToNextParticle;
				_timeToNextParticle = calcNextParticleTime();
				(create(BlurParticle) as BlurParticle).blur(_blur);
			}
			else
				_elapsed += FP.elapsed;
		}
		
		/* returns a random amount of time to wait before spawning a new particle */
		private function calcNextParticleTime():Number
		{
			return MIN_LAPSED_CREATE_TIME + (FP.random * MAX_ADDITIONAL_CREATE_TIME);
		}
		
		private function onBlurOutComplete():void 
		{
			trace("Blur Out done!");
		}		
		
		private function onBlurInComplete():void 
		{
			trace("Blur In done!");
		}
	}
}