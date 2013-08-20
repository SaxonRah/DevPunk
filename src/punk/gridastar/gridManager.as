package  
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Nirvan
	 */
	
	public class gridManager
	{
		public const grid:int = 8;
		public const gridWidth:int = Math.floor(FP.stage.width / grid);
		public const gridHeight:int = Math.floor(FP.stage.height / grid);
		public var powSize:int;
		
		public var gridCell:Array = [];
		public var openList:Array = [];
		public var path:Array = [];
		public var startPoint:Point;
		public var lastPoint:Point;
		public var goalPoint:Point;
		public var found:Boolean;
		public var step:int;
		public var state:Object = { Cell:int, F:int };
		
		
		public function gridManager()
		{
			found = false;
			lastPoint = new Point(gridRoom.startPoint.x / grid, gridRoom.startPoint.y / grid);
			startPoint = new Point();
			goalPoint = new Point();
			powSize = gridHeight * grid * gridWidth * grid;
			step = 0;			
			
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

				for(var i:int = 0; i < gridWidth*gridHeight; i++)
					gridCell[i].refresh(i, j);
						  
				openList.splice(0);
					
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
		 * Calculates F G H values for cell.
		 */
		public function calculateGHF(x:int, y:int, nx:int, ny:int, j:int, i:int):void
		{
			var cell:int = checkCell(x, y);
			var parCell:int = gridCell[ cell ].parent;
			gridCell[ cell ].G = gridCell[ parCell ].G + dirCost(0, 0, j, i); //dirCost zwraca 10 badz 14 zaleznie od tego czy to ruch na skos czy prosty
			gridCell[ cell ].H = manhattanDistance(x, y, nx, ny)*10; //odleglosc w kratkach*10 do punktu koncowego poprzez |endX-x|+|endY-y|
			gridCell[ cell ].F = gridCell[ cell ].G + gridCell[ cell ].H //wartosc F to suma G i H
		}
		
		/**
		 * Calculates F.
		 */
		public function calculateF(cell:int):int
		{
			return gridCell[ cell ].G + gridCell[ cell ].H;
		}
		
		/**
		 * Calculates H.
		 */
		public function calculateH(x:int, y:int):int
		{
			return manhattanDistance(x, y, goalPoint.x / grid, goalPoint.y / grid) * 10;
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
						
			if ( cell == checkCell(goalX,goalY) ) return; //If we got to position where we started our pathfinding, end function.
			step++; //so do next step with parent x and y
			reTrace(   needX( gridCell[ cell ].parent ),   needY( gridCell[ cell ].parent ), goalX, goalY, step);
		}
		
		
		/**
		 * Path finding.
		 */
		public function stepPlus(x:int, y:int, goalx:int, goaly:int):void
		{	
			var xx:int, yy:int; //temporary variables
			var cell:int = checkCell(x, y);

			if ( step == 0 ) //if it's first step, we must save source position
			{ 
				startPoint.x = x;
				startPoint.y = y;
				cellOperation(cell, 1);
				step++;
			}
			
			if (openList.length == 0) { trace("Ass"); found = true; } //if path isn't found ( list of open cells deleted all elements )

			if (openList.length || !found) //if there are cells for check
			{
				
				var cheapest:int = powSize;
				
				for (i = 0; i < openList.length; i++)
					{ cell = openList[i].Cell; if ( gridCell[ cell ].F < cheapest ) { j = i; cheapest = gridCell[ cell ].F; }	}
				
				cell = openList[j].Cell;
				x = needX(cell);
				y = needY(cell);
				
				cellOperation(cell, -1, j); //sets status to -1 and removes this cell from openList
				
				
				if ( cell == checkCell(goalx, goaly) ) //if we are in goal position
				{ 
					reTrace(x, y, startPoint.x, startPoint.y, 0); //we create a path points
					found = true; //tell that path is found
					return; //and don't doing anything else from function
				} 
				
				for( var i:int =-1; i < 2; i+= 1 )
					for( var j:int =-1; j < 2; j+= 1 )
						{
							if ( i == 0 && j == 0 ) continue; //if j and i coordinates are equal to 0 is means source position, we don't want and need to check this so we avoid this but continue search with j++
							
							xx = x + j; //temporary variables for speed
							yy = y + i;
							cell = checkCell(xx, yy); //takes id of cell from xx and yy ( left/right/.../diagonal from source position )
							var parCell:int = checkCell(x,y);
							
							if ( ( xx >= 0 && xx < gridWidth ) && ( yy >= 0 && yy < gridHeight ) ) //if value of xx and yy isn't out of range
								if ( gridCell[ cell ].value != 1 ) //if it isn't obstacle
								inspectCell(cell, parCell); //let's inspect this cell
						}
						
			}
			
			
		}
		
		
		/**
		 * Changes status of cell and save to record array.
		 */
		public function cellOperation(cell:int, open:int, index:int = 0):void
		{
			gridCell[ cell ].status = open;
			if (open == 1) openList.push({Cell:cell, F:gridCell[cell].F}); else openList.splice(index,1);
		}
		
		
		/**
		 * Inspects node.
		 */
		public function inspectCell(cell:int, parCell:int):void
		{
			//Push the node into the open list if this node is not
			//in the open list. Otherwise, if the node can be accessed
			//with a lower cost from the given parent position, update 
			//its parent and cost, then heapify the open list.

            if (gridCell[cell].status == 0)
            {    
				gridCell[cell].status = 1
				tryUpdate(cell, parCell);
				openList.push({Cell:cell, F:gridCell[cell].F});
				
				//Sorting F value in open list
				openList.sortOn(["Cell"]);
				
				
				
			}
            else tryUpdate(cell, parCell); //openList.sort();

		}
		
		
		/**
		 * Try to update the node's info with their parent.
		 */
		public function tryUpdate(cell:int, parCell:int):Boolean
		{
        //Try to update the node's info with the given parent.
        //If this node can be accessed with the given parent with lower
        //G cost, this node's parent, G and F values will be updated.
        //whether this node's info has been updated.
		
			var x:int = needX(cell), y:int = needY(cell);
			var parent:int = gridCell[cell].parent;
			var addCost:int = dirCost( needX(cell), needY(cell), needX(parCell), needY(parCell) );
			var newG:int = gridCell [ parCell ].G + addCost;

			if ( (gridCell[ cell ].G == 0) || (newG < gridCell[ cell ].G) )
			{

				gridCell[ cell ].G = newG;
				gridCell[ cell ].H = calculateH(x, y);
				gridCell[ cell ].F = calculateF(cell);
				gridCell[ cell ].parent = parCell;

				return true;
			}
			
			return false;
			
		}
		
	}

}