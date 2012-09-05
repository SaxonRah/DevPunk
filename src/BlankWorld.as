package 
{
    import net.flashpunk.*;
    import punk.ui.*;
    import punk.ui.skins.*;
	import Assets;

    public class BlankWorld extends World
    {

        public function BlankWorld()
        {
			PunkUI.skin = new Elite();
            var blankworld:* = new PunkWindow(200, 200, 200, 200, "BlankWorld");
            add(blankworld);
            return;
        }// end function
	}
}