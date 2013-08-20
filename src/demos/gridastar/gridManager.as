package  demos.gridastar
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Nirvan
	 */
	
	public class gridManager
	{
		public const grid:int=32;	//remember about changing it in gridRoom too
		public const gridWidth:int = Math.floor(FP.stage.width / grid);
		public const gridHeight:int = Math.floor(FP.stage.height / grid);
		public var powSize:int;
		
		public var gridCell:Array = [];
		public var openList:Array = [];
		public var checkedList:Array = [];
		public var path:Array = [];
		public var startPoint:Point;
		public var lastPoint:Point;
		public var goalPoint:Point;
		public var found:Boolean;
		public var step:int;
		
		
		public function gridManager()
		{
			var c:int = 0;
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
		 **/
		public function checkCell(x:int, y:int):int
		{
			return y * gridWidth + x;
		}
		
		
		/**
		 * Return x number from cell number.
		 **/
		public function needX(i:int):int
		{
			return i - gridWidth * Math.floor( i / gridWidth );
		}
		
		
		/**
		 * Return y number from cell number.
		 **/
		public function needY(i:int):int
		{
			return Math.floor ( i / gridWidth );
		}
		
		
		/**
		 * Refreshes all arrays to new search.
		 **/
		public function refresh(j:int=1):void
		{
				lastPoint.x = gridRoom.startPoint.x / grid;
				lastPoint.y = gridRoom.startPoint.y / grid;
				path.splice(0);

				for(var i:int = 0; i < gridWidth*gridHeight; i++)
					gridCell[i].refresh(i, j);
						  
				openList.splice(0);
				checkedList.splice(0);	
				
				found = false;
				step = 0;
		}

		
		/**
		 * Simple Manhattan distance.
		 **/
		public function manhattanDistance(x:int, y:int, nx:int, ny:int):int
		{
			return Math.abs(x - nx) + Math.abs(y - ny);
		}
		
		
		/**
		 * Cost of move in directions. Simple 10, diagonally 14 ( because of sqrt(2) = 1.414 but this is float type, we want smaller int so * 10 we have 14 )
		 **/
		public function dirCost(x:int, y:int, nx:int, ny:int):int
		{
			if ( manhattanDistance(x, y, nx, ny) == 1 ) return 10; else return 14;
		}
		
		
		/**
		 * Calculates F.
		 **/
		public function calculateF(cell:int):int
		{
			return gridCell[ cell ].G + gridCell[ cell ].H;
		}
		
		
		/**
		 * Calculates H.
		 **/
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
		 **/
		public function reTrace(x:int, y:int, goalX:int, goalY:int, step:int):void
		{
			var cell:int = checkCell(x, y);
			var parCell:int = gridCell[ cell ].parent;
			path[ step ] = new Point(x, y);
						
			if ( cell == checkCell(goalX,goalY) ) return; //If we got to position where we started our pathfinding, end function.
			step++; //so do next step with parent x and y
			reTrace( needX(parCell), needY(parCell), goalX, goalY, step);
		}
		
		
		/**
		 * Path finding based on A* algorithm.
		 **/
		public function stepPlus(x:int, y:int, goalx:int, goaly:int):void
		{	
			var xx:int, yy:int, j:int; //temporary variables
			var cell:int = checkCell(x, y);

			if ( step == 0 ) //if it's first step, we must save source position
			{ 
				startPoint.x = x;
				startPoint.y = y;
				cellOperation(cell, 1);
				step++;
			}
			

			if (openList.length) //if there are cells for check
			{
				
				var cheapest:int = powSize;
				
				for (var i:int = openList.length-1; i >=0; i--)
					{ cell = openList[i]; if ( gridCell[ cell ].F < cheapest ) { j = i; cheapest = gridCell[ cell ].F; }	}
				

				cell = openList[j];
				x = needX(cell);
				y = needY(cell);
				
				cellOperation(cell, -1, j); //sets status to -1 and removes this cell from openList
				
				if ( cell == checkCell(goalx, goaly) ) //if we are in goal position
				{ 
					reTrace(x, y, startPoint.x, startPoint.y, 0); //we create a path points
					found = true; //tell that path is found
					return; //and don't doing anything else from function
				} 
				var parCell:int = checkCell(x, y);
				
				diagonalMove(x, y, parCell, 0);
				horVertMove(x, y-1, parCell);
				diagonalMove(x, y, parCell, 1);
				horVertMove(x - 1, y, parCell);
				horVertMove(x + 1, y, parCell);
				diagonalMove(x, y, parCell, 2);
				horVertMove(x, y + 1, parCell);
				diagonalMove(x, y, parCell, 3);	
						
			} 
			else // if path not found
			{
				cheapest = powSize; //Let's find square with the cheapest cost
				for (i = 0; i < checkedList.length-1; i++)
					if ( gridCell[ checkedList[i] ].H < cheapest ) { cell = checkedList[i]; cheapest = gridCell[ cell ].H; }
					
				reTrace(needX(cell), needY(cell), startPoint.x, startPoint.y, 0);
				
				found = true;
			}
			
			
		}
		
		
		
		/**
		 * Path finding based on dijikstra algorithm.
		 */
		public function stepPlusD(x:int, y:int, goalx:int, goaly:int):void
		{	
			var cell:int = checkCell(x, y);
			
			if ( step == 0 ) //if it's first step, we must save source position
			{ 
				startPoint.x = x;
				startPoint.y = y;
				cellOperation(cell, 1);
				step++;
			}
			
			//if ( cell == checkCell(goalx, goaly) ) { reTrace(x, y, startPoint.x, startPoint.y,0); found = true; }
			
			if ( openList.length )
			{
				var xx:int, yy:int;

				cell = openList[0];
				cellOperation(cell, -1, 0); //sets status to -1 and removes this cell from openList
				
				if ( cell == checkCell(goalx, goaly) ) //if we are in goal position
				{ 
					reTrace(x, y, startPoint.x, startPoint.y, 0); //we create a path points
					found = true; //tell that path is found
					return; //and don't doing anything else from function
				}
				
				
					var parCell:int = checkCell(x, y);
					horVertMoveD(x - 1, y, parCell);
					horVertMoveD(x + 1, y, parCell);
					horVertMoveD(x, y - 1, parCell);
					horVertMoveD(x, y + 1, parCell);
					diagonalMoveD(x, y, parCell, 0);
					diagonalMoveD(x, y, parCell, 1);
					diagonalMoveD(x, y, parCell, 2);
					diagonalMoveD(x, y, parCell, 3);	
				
					lastPoint.x = needX(openList[0]);
					lastPoint.y = needY(openList[0]);
					
					//stepPlusD(lastPoint.x, lastPoint.y, goalx, goaly);
				
			} else { found = true; if (gridCell[gridRoom.mouseCell].value!=1) reTrace(needX(gridRoom.mouseCell), needY(gridRoom.mouseCell), startPoint.x, startPoint.y, 0); }
			
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
		 * Check move in diagonal move.
		 **/
		
		public function diagonalMoveD(x:int, y:int, parCell:int, dir:int):void
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
				if ( !diagonalIsNotWalkable(x, y, dir) ) inspectCellD(cell, parCell); 		//let's inspect this cell
		}
		
		
		/**
		 * Check move in horizontal or vertical move.
		 **/
		
		public function horVertMoveD(x:int, y:int, parCell:int):void
		{		
			var cell:int = checkCell(x, y);	
			if ( ( x >= 0 && x < gridWidth ) && ( y >= 0 && y < gridHeight ) ) //if value of x and y isn't out of grid range
				if ( gridCell[ cell ].value != 1 ) 	//if it isn't obstacle
				inspectCellD(cell, parCell); 		//let's inspect this cell
		}
		
		
		
		/**
		 * Quick sorting, maybe will be not used :P
		 **/
		
		public function quickSort(left:int, right:int):void
		{
			var i:int = left, j:int = right;
			var tmp:int;
			var pivot:int = gridCell[ openList[  Math.round( (left + right) / 2) ] ].F;
			  
			 /* partition */
			 while (i <= j) {
					while ( gridCell[ openList[i] ].F < pivot)
						  i++;
					while ( gridCell[ openList[j] ].F > pivot)
						  j--;
					if (i <= j) {
						  tmp =openList[i];
						  openList[i] = openList[j];
						  openList[j] = tmp;
						  i++;
						  j--;
					}
			  }
			  /* recursion */
			if (left < j)
				quickSort(left, j);
			if (i < right)
				quickSort(i, right);
		}
		
		
		/**
		 * Changes status of cell and save to record array.
		 **/
		public function cellOperation(cell:int, open:int, index:int = 0):void
		{
			gridCell[ cell ].status = open;
			if (open == 1) { openList.push(cell); checkedList.push(cell); } else openList.splice(index, 1);
		}
		
		
		/**
		 * Inspects node.
		 **/
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
				openList.push(cell);
				checkedList.push(cell);
			}
            else tryUpdate(cell, parCell); //openList.sort();

		}
		
		
		/**
		 * Try to update the node's info with their parent.
		 **/
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
		
		
		/**
		 * Inspects node.
		 */
		public function inspectCellD(cell:int, parCell:int):void
		{
			if (gridCell[cell].status == 0)
			{
				cellOperation(cell, 1);
				tryUpdateD(cell, parCell);
			}
		}
		
		
		/**
		 * Try to update the node's info with their parent.
		 */
		public function tryUpdateD(cell:int, parCell:int):void
		{
			var addCost:int = dirCost( needX(cell), needY(cell), needX(parCell), needY(parCell) );
			gridCell[ cell ].parent = parCell;
			gridCell[ cell ].G += addCost;
		}
		
		
	}

}