package demos.bloomnblur.bloom {
	
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
	import demos.bloomnblur.*;
	import demos.bloomnblur.bloom.*;
	import demos.bloomnblur.blur.*;
	import demos.gravityemit.*;
	import demos.lighting.*;
	import demos.ogmolevel.*;
	import demos.platformer.*;
	import demos.punkui.*;
	import demos.tinting.*;
	
	/**
	 * ...
	 * @author Reiss
	 */
	public class BloomLevel extends World
	{	
		/* time between particle creation */
		public static const MIN_LAPSED_CREATE_TIME:Number = 0.05;
		public static const MAX_ADDITIONAL_CREATE_TIME:Number = 0.025;
		
		/* amount of bloom and quality of bloom desired */
		private static const BLOOM:Number = 10.0;
		private static const BLOOM_QUALITY:int = 2;
		
		/* particle timing */
		private var _elapsed:Number = 0.0;
		private var _timeToNextParticle:Number = calcNextParticleTime();
		
		/* bloom effect */
		private var _bloom:BloomLighting = new BloomLighting(BLOOM, BLOOM_QUALITY);
		
		/* data */
		private var _wrappedGraphic:BloomWrapper;
		
		public function BloomLevel() {
		FP.log("Bloom World Started");	
		}
		
		override public function begin():void
		{
			
			//set the layer and color of the bloom, and add it to the world
			_bloom.layer = -1;
			_bloom.color = 0xafffff;
			add(_bloom);
			
			//create, add, and register an initial particle
			_bloom.register(create(BloomParticle).graphic as BloomWrapper);
			
			//create, add, and register some text
			var txt:Entity = new Entity();
			var img:Text;
			Text.size = 48;
			img = new Text("BloomPunk");
			txt.graphic = _wrappedGraphic = new BloomWrapper(img);
			txt.x = FP.width / 2 - img.width / 2;
			txt.y = FP.height / 2 - img.height / 2;
			img.outlineStrength = 7;
			img.outlineColor = 0x126576;
			img.updateTextBuffer();
			
			txt.layer = 1;
			
			_bloom.register(add(txt).graphic as BloomWrapper);
		}
		
		override public function update() : void {
			// Check which Key has been pressed
			if(Input.pressed(Key.X)) {
				Assets.updateWorld(true);
			} else if (Input.pressed(Key.Z)) {
				Assets.updateWorld(false);
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
				_bloom.register(create(BloomParticle).graphic as BloomWrapper);
			}
			else
				_elapsed += FP.elapsed;
				
			/*toggle the text blooming*/
			if (Input.pressed(Key.ENTER))
			{
				if (_wrappedGraphic.bloomCanvas)
					_bloom.unregister(_wrappedGraphic);
				else
					_bloom.register(_wrappedGraphic);
			}
		}
		
		private function onBlurOutComplete():void 
		{
			trace("Blur Out done!");
		}		
		
		private function onBlurInComplete():void 
		{
			trace("Blur In done!");
		}
		
		/* returns a random amount of time to wait before spawning a new particle */
		private function calcNextParticleTime():Number
		{
			return MIN_LAPSED_CREATE_TIME + (FP.random * MAX_ADDITIONAL_CREATE_TIME);
		}
		
	}

}