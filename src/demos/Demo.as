package demos {
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	import punk.ui.PunkPasswordField;
	import punk.ui.PunkRadioButton;
	import punk.ui.PunkRadioButtonGroup;
	import punk.ui.PunkTextArea;
	import punk.ui.PunkTextField;
	import punk.ui.PunkToggleButton;
	import punk.ui.PunkUI;
	import punk.ui.PunkWindow;
	import punk.ui.skins.RolpegeBlue;
	import punk.ui.skins.YellowAfterlife;
	import punk.ui.skins.Elite;
	import punk.ui.skin.*;
	import flash.display.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import punk.transition.*;
	import punk.transition.effects.*;
	
	public class Demo extends World {
		public var button:PunkButton;
		
		public function Demo() {
			FP.log("Demo World Started");
		}

		override public function begin() : void {
			var rg:PunkRadioButtonGroup = new PunkRadioButtonGroup;
			
			add(button = new PunkButton(5, 5, 200, 25, "Button"));
			button.setCallbacks(onReleased, onPressed, onEnter, onExit);
			add(new PunkToggleButton(5, 40, 200, 25, false, "ToggleButton"));
			add(new PunkRadioButton(rg, "", 5, 65, 200, 25, true, "Test1"));
			add(new PunkRadioButton(rg, "", 210, 65, 200, 25, false, "Test2" ));
			add(new PunkRadioButton(rg, "", 5, 90, 200, 25, false, "Test3"));
			add(new PunkRadioButton(rg, "", 210, 90, 200, 25, false, "Test4"));
			add(new PunkLabel("This is a label", 5, 125, 200, 25));
			add(new PunkTextArea("This is a TextArea", 5, 150, 200, 100));
			add(new PunkTextField("This is a text field", 5, 260, 200));
			add(new PunkPasswordField("", 5, 200, 100));
			add(new PunkWindow(5, 320, 200, 100, "Window!"));
			
			var skinSelector:PunkWindow = new PunkWindow(350, 225, 200, 200, "Select a skin:");
			var sg:PunkRadioButtonGroup = new PunkRadioButtonGroup;
			skinSelector.add(new PunkRadioButton(sg, "", 5, 25, 190, 25, PunkUI.skin is YellowAfterlife, "YellowAfterlife", changeToYellowAfterlife));
			skinSelector.add(new PunkRadioButton(sg, "", 5, 50, 190, 25, PunkUI.skin is RolpegeBlue, "RolpegeBlue", changeToRolpegeBlue));
			skinSelector.add(new PunkRadioButton(sg, "", 5, 75, 190, 25, PunkUI.skin is Elite, "Elite", changeToElite));
			add(skinSelector);
		}
		
		public function changeToYellowAfterlife(on:Boolean) : void {
			if(!on) return;
			PunkUI.skin = new YellowAfterlife;
			FP.world = new Demo;
		}
		
		public function changeToRolpegeBlue(on:Boolean) : void {
			if(!on) return
			PunkUI.skin = new RolpegeBlue;
			FP.world = new Demo;
		}
		
		public function changeToElite(on:Boolean) : void {
			if(!on) return
			PunkUI.skin = new Elite;
			FP.world = new Demo;
		}
		
		public function onPressed() : void {
			button.label.text = "pressed";
		}
		
		public function onReleased() : void {
			button.label.text = "released";
		}
		
		public function onEnter() : void {
			button.label.text = "enter";
		}
		
		public function onExit() : void {
			button.label.text = "exit";
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