package demos {
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;
    import net.flashpunk.*;
    import net.flashpunk.graphics.*;
    import net.flashpunk.utils.*;
	import demos.Assets;
	import punk.transition.*;
	import punk.transition.effects.*;

    public class TintWorld extends World {
        private var player:SidePlayer;
        private var slider:Entity;
        private var sliderBar:Image;
        private var sliderWidth:Number = 50;
        private var sliderHeight:Number = 400;
        private var sliderText:Text;
        private var blendMode:Number = 1;

        public function TintWorld() {
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_1:* = new BitmapData(FP.width, FP.height, false, 0);
            _loc_1.perlinNoise(256, 256, 10, FP.random, false, true);
            _loc_1.colorTransform(_loc_1.rect, new ColorTransform(0.25, 0.25, 0.25));
            addGraphic(new Backdrop(_loc_1, false, false));
            this.slider = new Entity(FP.width - this.sliderWidth * 1.5, FP.height * 0.5 - this.sliderHeight * 0.5);
            this.slider.width = this.sliderWidth;
            this.slider.height = this.sliderHeight;
            this.slider.addGraphic(Image.createRect(this.sliderWidth, this.sliderHeight, 0, 0.5));
            this.sliderBar = Image.createRect(this.sliderWidth, this.sliderHeight);
            this.sliderBar.originY = this.sliderHeight;
            this.sliderBar.y = this.sliderHeight;
            this.slider.addGraphic(this.sliderBar);
            this.sliderText = new Text("100", 0, -20);
            this.slider.addGraphic(this.sliderText);
			sliderText.outlineStrength = 5;
			sliderText.outlineColor = 0x0000000;
			sliderText.updateTextBuffer();
            add(this.slider);
            var _loc_2:* = [16777215, 8421504, 0, 16711680, 16776960, 65280, 65535, 255, 16711935];
            var _loc_3:* = [-2, -1, -0.5, 0.25, 0.5, 0.75, 1];
            var _loc_4:* = -1.5;
            var _loc_5:* = 1.5;
            var _loc_6:* = 13;
            _loc_8 = 0;
            while (_loc_8 < _loc_6) {
                addGraphic(new Text(String(_loc_4 + (_loc_5 - _loc_4) * (_loc_8 / (_loc_6 - 1)))), 0, 0, 15 + 50 * _loc_8);
                _loc_7 = 0;
				
                while (_loc_7 < _loc_2.length) {
                    this.player = new SidePlayer(60 + 60 * _loc_7, 5 + 50 * _loc_8);
                    this.player.sprSwordguy.tintMode = this.blendMode;
                    this.player.sprSwordguy.tinting = _loc_4 + (_loc_5 - _loc_4) * (_loc_8 / (_loc_6 - 1));
                    this.player.sprSwordguy.color = _loc_2[_loc_7];
                    add(this.player);
                    _loc_7++;
                }
                _loc_8++;
            }
            return;
        }
		
        override public function update() : void {
		
            var _loc_1:* = NaN;
            var _loc_2:* = null;
            var _loc_3:* = null;
			
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
			 //super.update();
			
            if (Input.mouseDown) {
                if (this.slider.collidePoint(this.slider.x, this.slider.y, mouseX, mouseY)) {
				
                    _loc_1 = 1 - (mouseY - this.slider.y) / this.sliderHeight;
                    this.sliderText.text = String(Math.round(_loc_1 * 100));
                    this.sliderBar.scaleY = _loc_1;
                    this.blendMode = _loc_1;
                    _loc_2 = new Vector.<SidePlayer>;
                    getClass(SidePlayer, _loc_2);
					
                    for each (_loc_3 in _loc_2) {
					
                        _loc_3.sprSwordguy.tintMode = this.blendMode;
						
                    }
                }
            }
            return;
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
