package  
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Nirvan
	 */
	
	public class gridManagerD
	{
		public const grid:int = 32;
		public const gridWidth:int = Math.floor(FP.stage.width / grid);
		public const gridHeight:int = Math.floor(FP.stage.height / grid);
		public var powSize:int;
		
		public var gridCell:Array = [];
		public var path:Array = [];
		public var openList:Array = [];
		public var startPoint:Point;
		public var lastPoint:Point;
		public var goalPoint:Point;
		public var found:Boolean;
		public var step:int;
		
		
		public function gridManagerD()
		{
			var c:int = 0;
			found = false;
			lastPoint = new Point(gridRoom.startPoint.x / grid, gridRoom.startPoint.y / grid);
			startPoint = new Point();
			goalPoint = new Point();		
			
			for (var i:int = 0; i < gridHeight*gridWidth; i++)
				gridCell[i] = new gridRectangle(i);
				
			gridCell[checkCell(6, 8)].value = 1;
			gridCell[checkCell(9, 8)].value = 1;
			gridCell[checkCell(10, 8)].value = 1;
			gridCell[checkCell(11, 8)].value = 1;
			gridCell[checkCell(14, 8)].value = 1;
		}
		
		
		/**
		 * Return cell's number by x and y numbers in grid (no pixels).
		 */
		public function checkCell(x:int, y:int):int
		{
			return y * gridWidth + x;
		}
		
		
		/**
		 * Return x number from cell number.
		 */
		public function needX(i:int):int
		{
			return i - gridWidth * Math.floor( i / gridWidth );
		}
		
		
		/**
		 * Return y number from cell number.
		 */
		public function needY(i:int):int
		{
			return Math.floor ( i / gridWidth );
		}
		
		
		/**
		 * Refreshes all arrays to new search.
		 */
		public function refresh(j:int=1):void
		{
				lastPoint.x = gridRoom.startPoint.x / grid;
				lastPoint.y = gridRoom.startPoint.y / grid;
				path.splice(0);
				openList.splice(0);

				for(var i:int = 0; i < gridWidth*gridHeight; i++)
					gridCell[i].refresh(i, j);
					
				found = false;
				step = 0;
		}

		
		/**
		 * Simple Manhattan distance.
		 */
		public function manhattanDistance(x:int, y:int, nx:int, ny:int):int
		{
			return Math.abs(x - nx) + Math.abs(y - ny);
		}
		
		
		/**
		 * Cost of move in directions. Simple 10, diagonally 14 ( because of sqrt(2) = 1.414 but this is float type, we want smaller int so * 10 we have 14 )
		 */
		public function dirCost(x:int, y:int, nx:int, ny:int):int
		{
			if ( manhattanDistance(x, y, nx, ny) == 1 ) return 10; else return 14;
		}
		
		
		/**
		 * Creating array of points from goal position to start position.
		 * @param current -> previous for next call reTrace x cell postion
		 * @param current -> previous for next call reTrace y cell postion
		 * @param not changed in callbacks goal x position
		 * @param not changed in callbacks goal y position
		 */
		public function reTrace(x:int, y:int, goalX:int, goalY:int, step:int):void
		{
			var cell:int = checkCell(x, y);
			path[ step ] = new Point(x, y);
						
			//if ( cell == checkCell(goalX,goalY) ) return; //If we got to position where we started our pathfinding, end function.
			//step++; //so do next step with parent x and y
			//reTrace(   needX( gridCell[ cell ].parent ),   needY( gridCell[ cell ].parent ), goalX, goalY, step);
		}
		
		
		/**
		 * Path finding.
		 */
		public function stepPlusD(x:int, y:int, goalx:int, goaly:int):void
		{	
			var cell:int = checkCell(x, y);
			gridCell[cell].status = 1;
			openList.push(cell);
			if ( cell == checkCell(goalx, goaly) ) found = true;
			
			if ( openList.length )
			{
				var xx:int, yy:int;

				cell = openList[0];
				cellOperation(cell, -1, 0); //sets status to -1 and removes this cell from openList
				
				if ( cell == checkCell(goalx, goaly) ) //if we are in goal position
				{ 
					//reTrace(x, y, startPoint.x, startPoint.y, 0); //we create a path points
					found = true; //tell that path is found
					return; //and don't doing anything else from function
				}
				
				
					var parCell:int = checkCell(x, y);
					horVertMove(x - 1, y, parCell);
					horVertMove(x + 1, y, parCell);
					horVertMove(x, y - 1, parCell);
					horVertMove(x, y + 1, parCell);
					diagonalMove(x, y, parCell, 0);
					diagonalMove(x, y, parCell, 1);
					diagonalMove(x, y, parCell, 2);
					diagonalMove(x, y, parCell, 3);	
				
					lastPoint.x = needX(openList[0]);
					lastPoint.y = needY(openList[0]);
				
				
			} else found = true;
			
		}
		
		
		
		/**
		 * Check if the diagonal move is walkable.
		 **/
		
		public function diagonalIsNotWalkable(x:int, y:int, dir:int):Boolean
		{		
			switch(dir)
			{
				case 0: if ( gridCell[ checkCell( x - 1, y ) ].value == 1 && gridCell[ checkCell( x, y - 1 ) ].value == 1 ) return true; break;
				case 1: if ( gridCell[ checkCell( x + 1, y ) ].value == 1 && gridCell[ checkCell( x, y - 1 ) ].value == 1 ) return true; break;
				case 2: if ( gridCell[ checkCell( x - 1, y ) ].value == 1 && gridCell[ checkCell( x, y + 1 ) ].value == 1 ) return true; break;
				case 3: if ( gridCell[ checkCell( x + 1, y ) ].value == 1 && gridCell[ checkCell( x, y + 1 ) ].value == 1 ) return true; break;
			}
			
			return false;
		}
		
		
		/**
		 * Check move in diagonal move.
		 **/
		
		public function diagonalMove(x:int, y:int, parCell:int, dir:int):void
		{
			var xx:int, yy:int;
			switch(dir)
			{
				case 0: xx = x - 1; yy = y - 1; break; // left up
				case 1: xx = x + 1; yy = y - 1; break; // right up
				case 2: xx = x - 1; yy = y + 1; break; // left down
				case 3: xx = x + 1; yy = y + 1; break; // right down
			}
			
			var cell:int = checkCell(xx, yy);
			
			if ( ( xx >= 0 && xx < gridWidth ) && ( yy >= 0 && yy < gridHeight ) ) //if value of x and y isn't out of grid range
				if ( gridCell[ cell ].value != 1 ) 	//if it isn't obstacle
				if ( !diagonalIsNotWalkable(x, y, dir) ) inspectCell(cell, parCell); 		//let's inspect this cell
		}
		
		
		/**
		 * Check move in horizontal or vertical move.
		 **/
		
		public function horVertMove(x:int, y:int, parCell:int):void
		{		
			var cell:int = checkCell(x, y);	
			if ( ( x >= 0 && x < gridWidth ) && ( y >= 0 && y < gridHeight ) ) //if value of x and y isn't out of grid range
				if ( gridCell[ cell ].value != 1 ) 	//if it isn't obstacle
				inspectCell(cell, parCell); 		//let's inspect this cell
		}
		
		
		
		/**
		 * Changes status of cell and save to record array.
		 */
		public function cellOperation(cell:int, open:int, index:int = 0):void
		{
			gridCell[ cell ].status = open;
			if (open == 1) openList.push(cell); else openList.splice(index, 1);
		}
		
		
		/**
		 * Inspects node.
		 */
		public function inspectCell(cell:int, parCell:int):void
		{
            if (gridCell[cell].status == 0)
            {    
				gridCell[cell].status = 1
				tryUpdate(cell, parCell);
				openList.push(cell);
			}
            else tryUpdate(cell, parCell);
		}
		
		
		/**
		 * Try to update the node's info with their parent.
		 */
		public function tryUpdate(cell:int, parCell:int):void
		{
			var addCost:int = dirCost( needX(cell), needY(cell), needX(parCell), needY(parCell) );
			gridCell[ cell ].G += addCost;
			gridCell[ cell ].parent = parCell;
		}
		
	}

}