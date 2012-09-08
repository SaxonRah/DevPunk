package {
	
    import net.flashpunk.*;
    import punk.ui.*;
    import punk.ui.skins.*;
	import Assets;

    public class MainWorld extends World {
		
        private var _txt:PunkTextArea;
        private var _txt2:PunkTextArea;
		private var _ow:PunkOptionWindow;
        private var _bar:BarChart;
        private var _line:LineChart;
		private var _step:Stepper;
        private var step:Number = 1;
		private var _numberX:* = 0;
		
        public function MainWorld() {
            PunkUI.skin = new Elite();
			
            var _loc_1:* = [];
            var _loc_2:* = 0;
			
            while (_loc_2 < 70) {
                _loc_1.push(Math.pow(_loc_2, 2));
                _loc_2 = _loc_2 + 1;
            }
			
			this._txt = new PunkTextArea("No Equipment Selected", 220, 10, 260, 200);
            add(this._txt);
			
			this._txt2 = new PunkTextArea("x30: Recovers 100HP", 220, 370, 260, 30);
            add(this._txt2);
			
			this._ow = new PunkOptionWindow(450, 450, 200, 200, "PunkUI Option Window", "Awesome ? \nChoose carefully...", true, 
							new Array(new PunkOptionButton("Yes", yesClicked), new PunkOptionButton("No", noClicked)));
			add(this._ow);
			
			this._step = new Stepper(220, 410, 200, 30)
			add(this._step);
			
			this._bar = new BarChart(10, 240, 200, 140, "Bar [y = x^2]", _loc_1);
            add(this._bar);
			
			this._line = new LineChart(220, 240, 260, 140, "Line [200 * sin(x/2) + 350]", []);
            add(this._line);
			
			var _loc_3:* = new PunkWindow(10, 30, 200, 200, "Weapons");
            add(_loc_3);
			
			var _loc_4:* = new PunkImageButton(10, 10, 180, 40, "Equip Sword", Assets.sword, this.onReleasedSword);
            _loc_3.add(_loc_4);
			
			var _loc_5:* = new PunkImageButton(10, 60, 180, 40, "Equip Flail", Assets.flail, this.onReleasedFlail);
            _loc_3.add(_loc_5);
			
			var _loc_6:* = new PunkImageButton(10, 110, 180, 40, "Equip Wand", Assets.wand, this.onReleasedWand);
			_loc_3.add(_loc_6);
			
			var skinSelector:PunkWindow = new PunkWindow(500, 250, 200, 100, "Select a Skin - Not working ?");
			var sg:PunkRadioButtonGroup = new PunkRadioButtonGroup;
			skinSelector.add(new PunkRadioButton(sg, "", 7, 5, 190, 25, PunkUI.skin is RolpegeBlue, "YellowAfterlife", changeToYellowAfterlife));
			skinSelector.add(new PunkRadioButton(sg, "", 7, 30, 190, 25, PunkUI.skin is RolpegeBlue, "RolpegeBlue", changeToRolpegeBlue));
			skinSelector.add(new PunkRadioButton(sg, "", 7, 55, 190, 25, PunkUI.skin is RolpegeBlue, "Elite", changeToElite));
			add(skinSelector);
			
			add(new PunkCombo(10, 372, 200, 28, ["Potion", "Hi Potion", "Ether"], this.onComboReleased));
			
            return;
        }// end function
		
		public function changeToYellowAfterlife(on:Boolean) : void {
			if(!on) PunkUI.skin = new YellowAfterlife;
			return;
		}
		
		public function changeToRolpegeBlue(on:Boolean) : void {
			if(!on) PunkUI.skin = new RolpegeBlue;
			return;
		}
		
		public function changeToElite(on:Boolean) : void {
			if(!on) PunkUI.skin = new Elite;
			return;
		}
		
        override public function update() : void {
            
            this.step = this.step - 0.1;
            var _loc_1:* = [];
            var _loc_2:* = 0;
			
            while (_loc_2 < 90) {
                
                _loc_1.push(400 * Math.sin(0.5 * _loc_2 + this.step) + 500);
                _loc_2 = _loc_2 + 1;
				
            }
			
            this._line.data = _loc_1;
			
			super.update();
        }

        private function onReleasedSword() : void {
            this._txt.text = "";
            this._txt.text = this._txt.text + "+------------------------+\n";
            this._txt.text = this._txt.text + "\tSword\n";
            this._txt.text = this._txt.text + "+------------------------+\n";
            this._txt.text = this._txt.text + "\tDamage:\t50pts\n";
            this._txt.text = this._txt.text + "\tWeight:\t\t30kgs\n";
            this._txt.text = this._txt.text + "\tCost:\t\t$45\n";
            this._txt.text = this._txt.text + "+------------------------+\n";
            return;
        }

        private function onReleasedFlail() : void {
            this._txt.text = "";
            this._txt.text = this._txt.text + "+------------------------+\n";
            this._txt.text = this._txt.text + "\tFlail\n";
            this._txt.text = this._txt.text + "+------------------------+\n";
            this._txt.text = this._txt.text + "\tDamage:\t80pts\n";
            this._txt.text = this._txt.text + "\tWeight:\t\t50kgs\n";
            this._txt.text = this._txt.text + "\tCost:\t\t$75\n";
            this._txt.text = this._txt.text + "+------------------------+\n";
            return;
        }

        private function onReleasedWand() : void {
            this._txt.text = "";
            this._txt.text = this._txt.text + "+------------------------+\n";
            this._txt.text = this._txt.text + "\tWand\n";
            this._txt.text = this._txt.text + "+------------------------+\n";
            this._txt.text = this._txt.text + "\tDamage:\t10pts\n";
            this._txt.text = this._txt.text + "\tWeight:\t\t20kgs\n";
            this._txt.text = this._txt.text + "\tCost:\t\t$145\n";
            this._txt.text = this._txt.text + "+------------------------+\n";
            return;
        }

        private function onComboReleased(param1:int) : void {
            switch(param1) {
                case 0: {
                    this._txt2.text = "x30: Recovers 100HP";
                    break;
                }
                case 1: {
                    this._txt2.text = "x10: Recovers 500HP";
                    break;
                }
                case 2: {
                    this._txt2.text = "x3: Recovers 100MP";
                    break;
                }
                default: {
                    break;
                }
            }
			return;
		}
		private function yesClicked() : void {
			FP.console.log("Yes Clicked");
			this.remove(_ow);
			return;
		}
		
		private function noClicked() : void {
			FP.console.log("No Clicked");
			return;
		}
		
		public function onUp() : void {
		}

		public function onDown() : void {
		}
    }
}
