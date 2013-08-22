package demos.box2d {
	import Box2D.Common.Math.b2Vec2;
	import punk.box2fp.Box2DWorld;
	
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	
	import demos.Assets;
	
	/**
	 * ...
	 * @author Ra
	 */
	public class B2DWorld extends Box2DWorld {
		
		public var i:Number = 0
		
		public function B2DWorld() {
			super();
			setGravity(new b2Vec2(0 , 9.8));
		}
		
		override public function begin():void {
			super.begin();
			doDebug();

			//top left to bottom left
			add(new B2DWall(0, 0, 5, 800));
			//top left to top right
			add(new B2DWall(5, 0, 800, 5));
			//top right to bottom right
			add(new B2DWall(795, 0, 5, 600));
			//bottom left to bottom right
			add(new B2DWall(5, 595, 800, 5));
		}
		override public function update():void {
			super.update();
			while (i < 10) {
				i++;
			add(new B2DEntity(80, 60));
			add(new B2DCircleEntity(700, 60));
			}
			//Check which Key has been pressed
			if (Input.pressed(Key.X)) {
				Assets.updateWorld(true);
			} else if (Input.pressed(Key.Z)) {
				Assets.updateWorld(false);
			}
		}
	}

}