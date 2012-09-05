package punk.ui
{
    import punk.ui.skin.*;

    public class PunkBackground extends PunkUIComponent
    {

        public function PunkBackground(x:Number = 0, y:Number = 0, width:int = 20, height:int = 20, skin:PunkSkin = null)
        {
            super(x, y, width, height, skin);
        }// end function

        override protected function setupSkin(x:PunkSkin) : void
        {
        }// end function

    }
}
