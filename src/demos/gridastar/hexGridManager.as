package  demos.gridastar
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Nirvan
	 */
	
	public class hexGridManager
	{
		public const gridH:int = 45;
		public const gridV:int = 41;
		
		public const gridWidth:int = Math.floor( (FP.stage.width-1) / gridH);
		public const gridHeight:int = Math.floor( (FP.stage.height-1) / gridV);
		
		public var powSize:int;
		
		public var gridCell:Array = [];
		public var openList:Array = [];
		public var checkedList:Array = [];
		public var path:Array = [];
		public var cells:Array = [];
		public var startPoint:Point;
		public var lastPoint:Point;
		public var goalPoint:Point;
		public var found:Boolean;
		public var step:int;
		
		
		public function hexGridManager()
		{
			found = false;
			lastPoint = new Point(hexGridRoom.startPoint.x / gridH, hexGridRoom.startPoint.y / gridV);
			startPoint = new Point();
			goalPoint = new Point();
			powSize = gridHeight * gridH * gridWidth * gridV;
			step = 0;	
			
			for (var i:int = 0; i < gridHeight*gridWidth; i++)
				gridCell[i] = new gridHex(i, needXPx(i), needYPx(i));
				
			gridCell[checkCell(2, 2)].value = 1;
			gridCell[checkCell(9, 4)].value = 1;
			gridCell[checkCell(5, 3)].value = 1;
		}
		
		
		/**
		 * Return cell's number by x and y numbers in grid (no pixels).
		 **/
		public function checkCell(x:int, y:int):int
		{
			return y * gridWidth + x;
		}
		
		
		/**
		 * Return cell's number by x and y numbers in grid (no pixels).
		 **/
		public function checkCellPx(x:int, y:int):int
		{	var yy:int = Math.floor(y / gridV);
			return yy * gridWidth + Math.floor(x / gridH); //+ (yy % 2) * gridH ;
		}
		
		
		/**
		 * Return x number from cell number.
		 **/
		public function needX(i:int):int
		{
			return i - gridWidth * Math.floor( i / gridWidth );
		}
		
		
		/**
		 * Return x coordinate from cell number.
		 **/
		public function needXPx(i:int):int
		{
			return (i - gridWidth * Math.floor( i / gridWidth )) * gridH + ( (needY(i) % 2)/2 ) * gridH;
		}
		
		
		/**
		 * Return y number from cell number.
		 **/
		public function needY(i:int):int
		{
			return Math.floor ( i / gridWidth );
		}
		
		
		/**
		 * Return y number from cell number.
		 **/
		public function needYPx(i:int):int
		{
			return Math.floor ( i / gridWidth ) * gridV;
		}
		
		
		/**
		 * Refreshes all arrays to new search.
		 **/
		public function refresh(j:int=1):void
		{
				lastPoint.x = hexGridRoom.startPoint.x / gridH;
				lastPoint.y = hexGridRoom.startPoint.y / gridV;
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
			return manhattanDistance(x, y, goalPoint.x / gridH, goalPoint.y / gridV) * 10;
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
				//for (var i:int = openList.length-1; i >=0; i--)
				for (var i:int =0 ; i <openList.length-1; i++)
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
					var even:int = y % 2;
					
					Move(x - 1 + even, y - 1, parCell); //left up
					Move(x + even, y - 1, parCell); // right up
					
					Move(x - 1, y, parCell); // left
					Move(x + 1, y, parCell); // right
					
					Move(x - 1 + even, y + 1, parCell); // left down
					Move(x + even, y + 1, parCell); // right down*/
						
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
			
			if ( cell == checkCell(goalx, goaly) ) { reTrace(x, y, startPoint.x, startPoint.y,0); found = true; }
			
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
					var even:int = y % 2;
					
					MoveD(x - 1 + even, y - 1, parCell); //left up
					MoveD(x + even, y - 1, parCell); // right up
					
					MoveD(x - 1, y, parCell); // left
					MoveD(x + 1, y, parCell); // right
					
					MoveD(x - 1 + even, y + 1, parCell); // left down
					MoveD(x + even, y + 1, parCell); // right down
					
					
				
					lastPoint.x = needX(openList[0]);
					lastPoint.y = needY(openList[0]);
				
				
			} else { found = true; if (gridCell[gridRoom.mouseCell].value!=1) reTrace(needX(gridRoom.mouseCell), needY(gridRoom.mouseCell), startPoint.x, startPoint.y, 0); }
			
		}
		
		
		
		/**
		 * Check move in horizontal or vertical move.
		 **/
		
		public function Move(x:int, y:int, parCell:int):void
		{		
			var cell:int = checkCell(x, y);	
			if ( ( x >= 0 && x < gridWidth ) && ( y >= 0 && y < gridHeight ) ) //if value of x and y isn't out of grid range
				if ( gridCell[ cell ].value != 1 ) 	//if it isn't obstacle
				inspectCell(cell, parCell); 		//let's inspect this cell
		}
		
		
		/**
		 * Check move in horizontal or vertical move.
		 **/
		
		public function MoveD(x:int, y:int, parCell:int):void
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
			var newG:int = gridCell [ parCell ].G + 10;

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
			gridCell[ cell ].parent = parCell;
			gridCell[ cell ].G += 10;
		}
		
		
	}

}