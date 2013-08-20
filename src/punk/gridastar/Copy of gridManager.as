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
		public const grid:int = 32;
		public const gridWidth:int = Math.floor(FP.stage.width / grid);
		public const gridHeight:int = Math.floor(FP.stage.height / grid);
		public var powSize:int;
		
		public var gridCell:Array = [];
		public var openList:Array = [];
		public var record:Array = [];
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
				record.splice(0);
					
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
		 */
		public function createPath(prex:int, prey:int, x:int, y:int, step:int):void
		{
			// 0 - goal x 1 - goal y    2 - start x 3 - start y
			var cell:int = checkCell(prex, prey);
			path[ step ]= new Point(prex, prey);
			if ( ( prex == x ) && ( prey == y ) ) return;
			step++;
			createPath(   needX(gridCell[ cell ].parent),   needY(gridCell[ cell ].parent), x, y, step);
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
			// 0 - goal x 1 - goal y    2 - start x 3 - start y
			var cell:int = checkCell(x, y);
			path[ step ] = new Point(x, y);
			
			/*
			 * trace(step + " x:" + x.toString() + " y:" + y.toString() + " goalX:" + goalX.toString() + " goalY:" + goalY.toString() );
			 * trace( "parentX: " + needX( gridCell[ cell ].parent).toString() + " parentY: "+ (needY( gridCell[ cell ].parent).toString()));
			 */
						
			if ( cell == checkCell(goalX,goalY) ) return; //If we got to position where we started our pathfinding, end function.
			step++; //so do next step with parent x and y
			reTrace(   needX( gridCell[ cell ].parent ),   needY( gridCell[ cell ].parent ), goalX, goalY, step);
		}
		
		
		/**
		 * Find the best rectangle from current.
		 */
		public function findBetter(x:int, y:int, goalx:int, goaly:int):void
		{
			var nx:int, ny:int, xx:int, yy:int, nearest:int, cell:int;
			nx = x; ny = y; //zmienne tymczasowe okreslajace nowy x i y do ktorego mamy sie udac
			nearest = powSize; //ta zmienna bedzie wyznaczac kratke ktora jest najbardziej kozystna do ruchu

			for(var i:int =-1; i<2; i+=1)
				for(var j:int =-1; j<2; j+=1)
				{
					
					if ( i == 0 && j == 0 ) continue;
					xx = x + j;
					yy = y + i;
					cell = checkCell(xx, yy);
					
					if ( ( xx >= 0 && xx < gridWidth ) && ( yy >= 0 && yy < gridHeight ) )
					 if ( gridCell[ cell ].value !=1 )
					 {
						if ( gridCell[ cell ].status == 0 ) //jesli kratka nie jest na liscie otwartych
						{ 
							//dodajemy ja i obliczamy wartosci
							gridCell[ cell ].parent = checkCell(x,y);
							calculateGHF( xx, yy, goalx, goaly, j, i);
							gridCell[ cell ].status = 1; //dodajemy do listy otwartych
						}
						
						if( gridCell[ cell ].status == 1 ) //jesli byla na sciezce             
							if( gridCell[ checkCell(x ,y) ].G + dirCost(0, 0, j, i) < gridCell[ gridCell[ cell ].parent ].G ) 
							//obliczamy wartosc ruchu dla tej kratki z aktualnego pola porownujac z kosztem ruchu do niej z kratki rodzica
							{ 
								gridCell[ cell ].parent = checkCell(x, y);
								calculateGHF( xx, yy, goalx, goaly, j, i);
								nx = xx; ny = yy;
							}
							
						//var parCell:int = checkCell( gridCell[ cell ].parentX, gridCell[ cell ].parentY );
						//if (	dirCost( gridCell[ parCell ].x, gridCell[ parCell ].y, xx, yy)   	!= 		dirCost( gridCell[ parCell ].parentX, gridCell[ parCell ].parentY, gridCell[ parCell ].x, gridCell[ parCell ].y)		)
							//gridCell[ cell ].G += 2;

					//if ( dirCost(parX[xx,yy],parY[xx,yy],xx,yy) != dirCost(parX[parX[xx,yy],parY[xx,yy]],parY[parX[xx,yy],parY[xx,yy]],parX[xx,yy],parY[xx,yy]) )
							
					}
				}

				/*for (i = 0; i < gridCell.length; i++)
					if (gridCell[i].open == 1) calculateGHF( needX(i), needY(i), goalx, goaly, gridCell[i].parentX-needX(i), gridCell[i].parentY-needY(i) );
				*/
					
				//zeby bylo steb by step co klikniecie to dajemy w mouse_pressed checkPlace(lx,ly)
				lastPoint.x = nx;
				lastPoint.y = ny; 
		}
		
		
		/**
		 * Find nearest to end point square and the cheapest from x & y.
		 */
		public function findNearest(x:int, y:int):void
		{
			var nx:int, ny:int, cell:int, nearest:int; //zmienne tymczasowe okreslajace nowy x i y do ktorego bedziemy mieli sie udac
			nearest = powSize; //ta zmienna bedzie wyznaczac kratke ktora jest najbardziej kozystna do ruchu
			nx=-1;//ta zmienna nie zmieni sie jesli sciezka do celu nie istnieje

			for(var i:int = 0; i < gridWidth; i+= 1 ) //sprawdza wszystkie kratki ktore sa otwarte
				for (var j:int = 0; j < gridHeight; j += 1 )
				{	cell = checkCell(i, j);
					if ( gridCell[ cell ].status == 1 ) //jesli czeka na sprawdzenie || jest na liscie otwartch
						if ( gridCell[ cell ].F < nearest ) //jesli wartosc F w kratce jest mniejsza od poprzednio sprawdzanej
						{ 
							nx = i; ny = j; //ustawiamy jej x i y jako nowy korzystny x i y
							nearest = gridCell[ cell ].F; //dodajemy jej wartosc F jako aktualnie najmniejsza
						}
				}

			if ( nx ==-1 && !found ) { trace("ass"); found=true; return; }//jesli nie znaleziono sciezki przerywamy wszystko
			gridCell[ checkCell(nx, ny) ].status =-1; //kratke z najmniejszym f dodajemy do zamknietych
			findBetter(nx, ny, x, y); //i szukamy z niej drogi
		}
		
		
		/**
		 * First step on patch finding.
		 */
		public function checkPlace(x:int, y:int, goalx:int, goaly:int):void
		{
			if ( step == 0 ) { startPoint.x = x; startPoint.y = y; }
			var cell:int = checkCell(x, y), xx:int, yy:int;
			gridCell[ cell ].status =-1; //zamykamy aktualne pole

			if ( x == goalx && y == goaly) //jesli jestesmy w punkcie docelowym
			{ createPath(x, y, startPoint.x, startPoint.y, 0); found = true; return; } //zamykamy to miejsce i oglaszamy znalezienie drogi i nie wykonujemy dalszych instrukcji
			
			for( var i:int =-1; i < 2; i+= 1 )
				for( var j:int =-1; j < 2; j+= 1 )
					{
						if ( i == 0 && j == 0 ) continue; //jesli aktualnie ma byc sprawdzana srodkowa kratka to opuszczamy to miejsce i sprawdzamy nastepna
						
						xx = x + j; //zmienne tymczasowe zeby bylo mniej pisania
						yy = y + i;
						cell = checkCell( xx, yy);
						
						if ( ( xx >= 0 && xx < gridWidth ) && ( yy >= 0 && yy < gridHeight ) ) //gdy wartosc sprawdzanej tablicy nie wyjdzie poza ekran
							if ( gridCell[ cell ].status != -1 && gridCell[ cell ].value!=1 ) //jesli nie ma tam przeszkody i nie jest w liscie zamknietych
							
							{
								calculateGHF( xx, yy, goalx, goaly, j, i); //obliczamy wartosci G[xx,yy],F[xx,yy]... sa to dosyc proste obliczenia
								gridCell[ cell ].parent = checkCell(x, y); //srodkowa kratka staje sie rodzicem wszystkich dookola niej
								gridCell[ cell ].status = 1; //dodajemy do listy otwartych
							}
					}
			step++;
			findNearest(goalx, goaly); //jesli nie znaleziono jeszcze sciezki (break ^) to sprawszamy do ktorej kratki z otwartych powinnismy sie udac
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

			if (openList.length || !found) //if there are cells for check
			{
				//var parCell:int = cell; //used later, in for
				var cheapest:int = powSize;
				
				for (i = 0; i < openList.length; i++)
					{ cell = openList[i]; if ( gridCell[ cell ].F < cheapest ) { j = i; cheapest = gridCell[ cell ].F; }	}
				
				cell = openList[j];
				x = needX(cell);
				y = needY(cell);
					
				/*
				 * trace( "Cheapest: " + cheapest.toString() + " cell F: " + (gridCell[cell].F).toString() + " H: " + (gridCell[cell].H).toString()  + " cell id: " + cell.toString() + " x: " + (needX(cell)).toString() + " y: " + (needY(cell)).toString() );
				 * trace( "How about on y = 7? F: " + (gridCell[checkCell(4,7)].F).toString() + " H: " + (gridCell[checkCell(4,7)].H).toString()  );
				 */
				
				
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
			if (open == 1) openList.push(cell); else openList.splice(index,1);
			record.push(cell);
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
				//cellOperation(cell, 1);
				gridCell[cell].status = 1
				
                if (record.length)
                {   
					record.push(cell);
					tryUpdate(cell, parCell);
					openList.push(cell);
				}
			}
            //else if ( tryUpdate(cell) ) openList.sort();
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
			
			var addCost:int = dirCost( needX(cell), needY(cell), needX(parent), needY(parent) );
			
			/*
			 * trace ( needX(cell).toString() + " " + needY(cell).toString() + " cell");
			 * trace ( needX(parent).toString() + " " + needY(parent).toString() + " parent");
			 * trace ( goalPoint.x.toString() + " " + goalPoint.y.toString() + " goalPoint");
			 */
			
			var newG:int = gridCell [ parent ].G + addCost;

			if ( (gridCell[ cell ].G == 0) || (newG < gridCell[ cell ].G) )
			{
				gridCell[ cell ].G = newG;
				gridCell[ cell ].H = calculateH(x, y);
				gridCell[ cell ].F = calculateF(cell);
				gridCell[ cell ].parent = parCell;

				if (record.length)
				{
					//record.append(('VALUE', ('g', (x, y), node.g)))
					//record.append(('VALUE', ('h', (x, y), node.h)))
					//record.append(('VALUE', ('f', (x, y), node.f)))
					//record.append(('PARENT', ((x, y), (px, py))))
					return true;
				}
				
			}
			
			return false;
			
		}
		
	}

}