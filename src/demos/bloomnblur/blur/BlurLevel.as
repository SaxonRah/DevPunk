package demos.bloomnblur.blur 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
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
			_blur.layer = -2;
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
			img.outlineStrength = 7;
			img.outlineColor = 0xFF34B3;
			img.updateTextBuffer();
			
			txt.layer = 1;
			
			add(txt);
		}
		
		override public function update():void
		{
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