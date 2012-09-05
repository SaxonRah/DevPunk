package {
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
	
	public class Demo extends World {
		public var button:PunkButton;
		
		public function Demo() {
			super();
		}

		override public function begin():void {
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
			
			var skinSelector:PunkWindow = new PunkWindow(350, 225, 200, 100, "Select a skin:");
			var sg:PunkRadioButtonGroup = new PunkRadioButtonGroup;
			skinSelector.add(new PunkRadioButton(sg, "", 5, 25, 190, 25, PunkUI.skin is YellowAfterlife, "YellowAfterlife", changeToYellowAfterlife));
			skinSelector.add(new PunkRadioButton(sg, "", 5, 50, 190, 25, PunkUI.skin is RolpegeBlue, "RolpegeBlue", changeToRolpegeBlue));
			skinSelector.add(new PunkRadioButton(sg, "", 5, 75, 190, 25, PunkUI.skin is Elite, "Elite", changeToElite));
			add(skinSelector);
		}
		
		public function changeToYellowAfterlife(on:Boolean):void {
			if(!on) return;
			PunkUI.skin = new YellowAfterlife;
			FP.world = new Demo;
		}
		
		public function changeToRolpegeBlue(on:Boolean):void {
			if(!on) return
			PunkUI.skin = new RolpegeBlue;
			FP.world = new Demo;
		}
		
		public function changeToElite(on:Boolean):void {
			if(!on) return
			PunkUI.skin = new Elite;
			FP.world = new Demo;
		}
		
		public function onPressed():void {
			button.label.text = "pressed";
		}
		
		public function onReleased():void {
			button.label.text = "released";
		}
		
		public function onEnter():void {
			button.label.text = "enter";
		}
		
		public function onExit():void {
			button.label.text = "exit";
		}
	}
}