package punk.ui
{
    import punk.ui.skin.*;

    public class Stepper extends PunkPanel
    {
        private var _txt:PunkTextArea;
        private var _downButton:PunkButton;
        private var _upButton:PunkButton;
        private var _buttonWidth:Number = 30;

        public function Stepper(param1:Number = 0, param2:Number = 0, param3:int = 20, param4:int = 20, param5:PunkSkin = null)
        {
            super(param1, param2, param3, param4, param5);
            this._txt = new PunkTextArea("0", 0, 0, param3 - this._buttonWidth - this._buttonWidth, param4);
            this._downButton = new PunkButton(param3 - this._buttonWidth - this._buttonWidth, 2, this._buttonWidth, param4 - 4, "-", this.onDown);
            this._upButton = new PunkButton(param3 - this._buttonWidth, 2, this._buttonWidth, param4 - 4, "+", this.onUp);
            add(this._txt);
            add(this._downButton);
            add(this._upButton);
            return;
        }// end function

        private function onUp() : void
        {
            this._txt.text = String((Number(this._txt.text) + 1));
            return;
        }// end function

        private function onDown() : void
        {
            this._txt.text = String((Number(this._txt.text) - 1));
            return;
        }// end function

    }
}
