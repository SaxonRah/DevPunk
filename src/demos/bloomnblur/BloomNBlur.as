package demos.bloomnblur {
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import punk.transition.*;
	import punk.transition.effects.*;
	
	import demos.*;
	import demos.Assets;
	import demos.bloomnblur.bloom.*;
	import demos.bloomnblur.blur.*;
	import demos.gravityemit.*;
	import demos.lighting.*;
	import demos.ogmolevel.*;
	import demos.platformer.*;
	import demos.punkui.*;
	import demos.tinting.*;
	
	public class BloomNBlur extends World {
		
		/* time between particle creation */
		public static const MIN_LAPSED_CREATE_TIME:Number = 0.05;
		public static const MAX_ADDITIONAL_CREATE_TIME:Number = 0.025;
		
		/* amount of bloom and quality of bloom desired */
		private static const BLOOM:Number = 10.0;
		private static const BLOOM_QUALITY:int = 2;
		
		/* amount of motion blur desired */
		private static const BLUR:Number = 0.8
		
		/* particle timing */
		private var _elapsed:Number = 0.0;
		private var _timeToNextParticle:Number = calcNextParticleTime();
		
		/* bloom effect */
		private var _bloom:BloomLighting = new BloomLighting(BLOOM, BLOOM_QUALITY);
		
		/* blur effect */
		private var _blur:BlurCanvas = new BlurCanvas(BLUR);
		
		/* data */
		private var _wrappedGraphic:BloomWrapper;
		
		public function BloomNBlur() {
		FP.log("BloomNBlur Started");	
		}
		
		override public function begin() : void {
			
			//set the layer and color of the bloom, and add it to the world
			_bloom.layer = -1;
			_bloom.color = 0xafffff;
			add(_bloom);
			
			//set the layer of the blur and add it to the world
			_blur.layer = 1;
			add(_blur);
			
			//create, add, and register an initial particle
			_bloom.register(create(BloomParticle).graphic as BloomWrapper);
			(create(BlurParticle) as BlurParticle).blur(_blur);
			
			//create, add, and register some text
			var txt:Entity = new Entity();
			var img:Text;
			Text.size = 48;
			img = new Text("Bloom N Blur Punk");
			txt.graphic = _wrappedGraphic = new BloomWrapper(img);
			txt.x = FP.width / 2 - img.width / 2;
			txt.y = FP.height / 2 - img.height / 2;
			
			img.outlineStrength = 7;
			img.outlineColor = 0x126534;
			img.updateTextBuffer();
			
			_bloom.register(add(txt).graphic as BloomWrapper);
		}
		
		override public function update() : void {
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
			if (_elapsed >= _timeToNextParticle) {
				_elapsed -= _timeToNextParticle;
				_timeToNextParticle = calcNextParticleTime();
				_bloom.register(create(BloomParticle).graphic as BloomWrapper);
				(create(BlurParticle) as BlurParticle).blur(_blur);
			}
			else
				_elapsed += FP.elapsed;
				
			/*toggle the text blooming*/
			if (Input.pressed(Key.ENTER)) {
				if (_wrappedGraphic.bloomCanvas)
					_bloom.unregister(_wrappedGraphic);
				else
					_bloom.register(_wrappedGraphic);
			}
		}
		
		/* returns a random amount of time to wait before spawning a new particle */
		private function calcNextParticleTime() : Number {
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