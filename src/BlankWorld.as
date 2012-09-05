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
            var blankworld:* = new PunkWindow(160, 120, 200, 200, "PunkUI");
            add(blankworld);
            return;
        }// end function
	}
}