package  demos.gridastar
{
	import flash.geom.Point;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import demos.Assets;
	
	/**
	 * ...
	 * @author Nirvan
	 */
	public class hexGridRoom extends World 
	{
		public static const gridH:int = 45;
		public static const gridV:int = 41;
		public static var mouseCell:int;
		public static var startPoint:Point;
		public static var goalPoint:Point;
		private var mover:int;
		private var gridControll:hexGridManager;
		protected var lastCell:int;
		protected var searcher:int;
		protected var infoTxt:Text;
		protected var show:Boolean;
		
		protected var cellTxt:Array = [];
		
		public function hexGridRoom() 
		{
			startPoint = new Point(1 * gridH, 4 * gridV);
			goalPoint = new Point(5 * gridH, 4 * gridV);
			lastCell = 0;
			mover = 0;
			searcher = 0;
			show = true;
			
			infoTxt = new Text("A* Pathfinding by Nirvan\nClick on red/green square to move them.\nClick on cells to add/remove obstacle.\nspace - step by step finding.\nenter - fps finding, shift - finding immediately.\nS - hold immediately, delete - to clear map.\nD - based on Dijiktra search, F - immediately\nG - go to rectangle grid Q - to hide this", 15, 15);
		}
		
		override public function begin():void 
		{
			gridControll = new hexGridManager();
			
			for (var i:int = 0; i < gridControll.gridWidth * gridControll.gridHeight; i++)
				{	cellTxt[i] = new Text("", gridControll.needXPx(i), gridControll.needYPx(i) );
					cellTxt[i].font = "font"; cellTxt[i].size = 8; cellTxt[i].color = 0xFFFFFF; }
			super.begin();
		}
		
		override public function update():void 
		{
			// Check which Key has been pressed
			if(Input.pressed(Key.X)) {
				Assets.updateWorld(true);
			} else if (Input.pressed(Key.Z)) {
				Assets.updateWorld(false);
			}
			
			mouseCell = gridControll.checkCell(Math.round(mouseX / gridH), Math.round(mouseY / gridV));
			gridControll.goalPoint = goalPoint;
			
			if ( Input.mouseDown )
			{
				var onCell:int = 0; 
				if (	( mouseX > 0 && mouseX < gridControll.gridWidth*gridH ) &&
						( mouseY > 0 && mouseY < gridControll.gridHeight*gridV)	) onCell = gridControll.checkCellPx(mouseX, mouseY);
				
				

				if ( Input.mousePressed &&
				( mouseX > startPoint.x && mouseX < startPoint.x + gridH ) &&
				( mouseY > startPoint.y && mouseY < startPoint.y + gridV ) ) mover = 1;
				
				if ( Input.mousePressed &&
				( mouseX > goalPoint.x && mouseX < goalPoint.x + gridH ) &&
				( mouseY > goalPoint.y && mouseY < goalPoint.y + gridV ) ) mover = 2;
				
				switch(mover)
				{
					case 1: startPoint.x = gridControll.needXPx(onCell);  startPoint.y = gridControll.needYPx(onCell); gridControll.lastPoint.x = startPoint.x / gridH; gridControll.lastPoint.y = startPoint.y / gridV; gridControll.refresh(0);	break;
					case 2: goalPoint.x = gridControll.needXPx(onCell);  goalPoint.y = gridControll.needYPx(onCell); gridControll.refresh(0); break;
				}
				
				//if (Input.mousePressed) trace( gridControll.gridCell[onCell].parent + " index: " + onCell.toString() );
				
				if ( mover == 0 )
				{
					if ( onCell )
					{
						switch( gridControll.gridCell[onCell].value )
						{
							case 0: if (lastCell != onCell) gridControll.gridCell[onCell].value = 1; lastCell = onCell; break;
							case 1: if (lastCell != onCell) gridControll.gridCell[onCell].value = 0; lastCell = onCell; break;
						}
					}
				}
				
			}
			//&& ( !gridControll.found )
			if ( Input.pressed(Key.SPACE)  ) gridControll.stepPlus(gridControll.lastPoint.x, gridControll.lastPoint.y, goalPoint.x/gridH, goalPoint.y/gridV);
			if ( Input.pressed(Key.ENTER)  ) { gridControll.refresh(0); searcher = 1; }
			if ( Input.pressed(Key.SHIFT)  ) { gridControll.refresh(0); searcher = 2; }
			if ( Input.check(Key.S)  ) { gridControll.refresh(0); searcher = 2; }
			if ( Input.check(Key.D)  ) { gridControll.refresh(0); searcher = 3; }
			if ( Input.check(Key.F)  ) { gridControll.refresh(0); searcher = 4; }
			if ( Input.pressed(Key.DELETE) ) gridControll.refresh();
			if ( Input.pressed(Key.Z) ) gridControll.stepPlus(startPoint.x/gridH, startPoint.y/gridV, goalPoint.x/gridH, goalPoint.y/gridV);
			if ( Input.pressed(Key.G) ) FP.world = new gridRoom;
			if ( Input.pressed(Key.Q) ) show = !show;
			
			if ( searcher == 1 )
				if ( gridControll.found ) searcher = 0;
					else gridControll.stepPlus(gridControll.lastPoint.x, gridControll.lastPoint.y, goalPoint.x/gridH, goalPoint.y/gridV);

			while ( searcher == 2 )
				if ( gridControll.found ) searcher = 0;
					else gridControll.stepPlus(gridControll.lastPoint.x, gridControll.lastPoint.y, goalPoint.x / gridH, goalPoint.y / gridV);

			if ( searcher == 3 )
				if ( gridControll.found ) searcher = 0;
					else gridControll.stepPlusD(gridControll.lastPoint.x, gridControll.lastPoint.y, goalPoint.x/gridH, goalPoint.y/gridV);

			while ( searcher == 4 )
				if ( gridControll.found ) searcher = 0;
					else gridControll.stepPlusD(gridControll.lastPoint.x, gridControll.lastPoint.y, goalPoint.x / gridH, goalPoint.y / gridV);

	
			if ( Input.mouseReleased ) mover = 0;
			
			super.update();
		}
		
		override public function render():void 
		{
			
			if ( gridControll.found )
				for (i = 0; i < int(gridControll.path.length) - 1; i++)
				{ var pcell:int = gridControll.checkCell(gridControll.path[i].x,gridControll.path[i].y), ncell:int = gridControll.checkCell(gridControll.path[i+1].x, gridControll.path[i+1].y);
					Draw.linePlus( gridH / 2 + gridControll.needXPx( pcell ), gridV / 2 + gridControll.needYPx( pcell ), gridH / 2 + gridControll.needXPx( ncell ), gridV / 2 + gridControll.needYPx( ncell ), 0xDDDD22, 1, 3);//gridControll.path[i + 1].x, gridControll.path[i + 1].y	
				}

			var i:int;
			for (i = 0; i < gridControll.gridWidth * gridControll.gridHeight; i++)
			{
				var parCell:int = gridControll.gridCell[i].parent;
				switch(gridControll.gridCell[i].status)
				{
					case  0: 	break;
					case -1:	Draw.rect(gridControll.needXPx(i), gridControll.needYPx(i)+10, gridH, gridV-10, 0x1111AA, .2); break;
					case  1: 	Draw.rect(gridControll.needXPx(i), gridControll.needYPx(i)+10, gridH, gridV-10,0x11AA11, .2);  break;
				}
				//cellTxt[i].text = "F:"+(gridControll.gridCell[i].F).toString()+"\nG:"+(gridControll.gridCell[i].G).toString()+"\nH:"+(gridControll.gridCell[i].H).toString();
				//cellTxt[i].text = "G:"+(gridControll.gridCell[i].G).toString() +"\n"+gridControll.gridCell[i].status;
				//cellTxt[i].render(FP.buffer, FP.zero, FP.camera);
				
				switch(gridControll.gridCell[i].value)
				{
					case 0: break;
					case 1: Draw.rect(gridControll.needXPx(i), gridControll.needYPx(i)+10, gridH, gridV-10, 0x777777); break;
				}
				
			}
			
			Draw.rect(startPoint.x, startPoint.y+10, gridH, gridV-10, 0x00FF00);
			Draw.rect(goalPoint.x, goalPoint.y+10, gridH, gridV-10, 0xFF0000);
			
			
			
			for (i = 0; i < gridControll.gridWidth * gridControll.gridHeight; i++)
			{
				parCell = gridControll.gridCell[i].parent;
				switch(gridControll.gridCell[i].status)
				{
					case  0: 	break;
					case -1:	Draw.line(gridH/2+gridControll.needXPx(i), gridV/2+gridControll.needYPx(i), gridH/2+gridControll.needXPx(parCell), gridV/2+gridControll.needYPx(parCell),0xAAAAAA); break;
					case  1: 	Draw.line(gridH/2+gridControll.needXPx(i), gridV/2+gridControll.needYPx(i), gridH/2+gridControll.needXPx(parCell), gridV/2+gridControll.needYPx(parCell),0xAAAAAA); break;
				}
				
				gridControll.gridCell[i].image.render(FP.buffer, FP.zero, FP.camera);
				
			}
			

					
			if (show)
			{
			Draw.rectPlus(10, 10, 325, 160, 0xCCCCCC, .3, true, 1, 5);
			infoTxt.render(FP.buffer, FP.camera, FP.camera);
			}
			
			
			
			
			super.render();
		}
		
	}

}