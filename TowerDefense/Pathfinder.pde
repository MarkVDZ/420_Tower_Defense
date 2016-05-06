class Pathfinder {
  ArrayList<Tile> opened = new ArrayList<Tile>(); 
  ArrayList<Tile> closed = new ArrayList<Tile>();

  Pathfinder() {
  }
  ArrayList<Tile> findPath (Tile start, Tile end) {
    opened.clear(); //empty opened tiles array
    closed.clear(); //empty closed tiles array

    start.resetParent();

    //Setp 1: CONNECT START TO END
    connectStartToEnd(start, end);
    //Step 2: BUILD PATH BACK TO THE START
    ArrayList<Tile> path = connectEndToStart(start, end);
    for (int i = path.size()-1; i>=0; i--){
      if(path.get(i).TERRAIN == 2 || path.get(i).TERRAIN == 5 || path.get(i).TERRAIN == 6) return null;
    }
    
    //Step 3: REVERSE THE PATH FOR CONVENIENCE
    ArrayList<Tile> reverse = new ArrayList<Tile>();
    for (int i = path.size()-1; i>=0; i--)reverse.add(path.get(i));
    return reverse;
  }

  void connectStartToEnd(Tile start, Tile end) {
    opened.add(start); //Add start TILE to opeded array 

    //WHILE WE STILL HAVE TILES IN THE OPEN ARRAY
    while (opened.size()>0) {
      //FIND OPEN TILE WITH THE LOWEST F VALUE
      float F = 99999;
      int index = -1;
      for (int i = 0; i < opened.size(); i++) {
        if (opened.get(i).F<F) {
          F = opened.get(i).F;
          index = i;
        }
      }

      Tile current = opened.remove(index); //remove current tile from opened array
      closed.add(current); //add the tile to the closed array

      if (current == end) break;

      //IF NEIGHBORS AREN'T IN EITHER THE CLOSED OR OPENED ARRAYS, ADD THEM TO OPENED
      for (int i = 0; i< current.neighbors.size(); i++) {
        Tile neighbor = current.neighbors.get(i);
        if (!tileInArray(closed, neighbor)) {
          if (!tileInArray(opened, neighbor)) {
            opened.add(neighbor);
            neighbor.setParent(current);
            neighbor.doHeuristic(end);
          }
        }
        //ELSE IF IT WOULD BE CHEAPER TO MOVE TO THAT TILE FROM CURRENT
        //SET IT'S PARENT TO CURRENT
        //RECLACULATE H VALUE
        else {
          if (neighbor.G > current.G + neighbor.getTerrainCost()) {
            neighbor.setParent(current);
            neighbor.doHeuristic(end);
          }
        }
      }
    }
  }

  ArrayList<Tile> connectEndToStart(Tile start, Tile end) {
    ArrayList<Tile> path = new ArrayList<Tile>();
    Tile pathNode = end;
    while (pathNode != null) {
      path.add(pathNode);
      pathNode = pathNode.parent;
    }
    return path;
  }

  boolean tileInArray(ArrayList<Tile> a, Tile t) {
    for (Tile tile : a)if (tile == t)return true;
    return false;
  }
}