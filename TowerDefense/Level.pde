class Level {
  int[][] level;
  Tile[][] tiles;
  Tile startTile;
  Tile endTile;

  Level() {
    loadLevel(LevelDefs.LEVEL2);
  }


  void draw() {
    noStroke();
    for (int Y = 0; Y < tiles.length; Y++) {
      for (int X = 0; X < tiles[Y].length; X++) {
        tiles[X][Y].update();
        tiles[Y][X].draw();
      }
    }
    fill(0);
  }


  /////////////////////////////////////////////////////////////////
  ////////////////PATHFINDING METHODS GO HERE//////////////////////
  /////////////////////////////////////////////////////////////////
  Tile getTile(int X, int Y) {
    if (X < 0 || Y < 0) return null;
    if (X>=tiles[0].length || Y >=tiles.length)return null;

    return tiles[Y][X];
  }
  PVector getTileCenter(Point p) {
    Tile tile = getTile(p.x, p.y);
    if (tile == null) return new PVector();
    return(tile.getCenter());
  }
  boolean isPassable(Point p) {
    Tile tile = getTile(p.x, p.y);
    if (tile == null) return false;
    if (tile.TERRAIN != 2) return false;
    if (tile.TERRAIN != 5) return false;
    if (tile.TERRAIN != 6) return false;
    return true;
  }
  /////////////////////////////////////////////////////////////////
  ////////////////END PATHFINDING STUFF////////////////////////////
  /////////////////////////////////////////////////////////////////
  //reloads the level.
  //useful for re-establishing neigbor relationships between tiles
  void reloadLevel() {
    loadLevel(level);
  }

  void setTile(Point p, int type) {
    Tile tile = getTile(p.x, p.y);
    if (tile != null) {
      tile.TERRAIN = type;
    }
  }

  void loadLevel(int[][] layout) {

    level = layout; // cache the layout (to enable reloading levels)

    // build our multidimensional array of tiles:
    int ROWS = layout.length;
    int COLS = layout[0].length;
    tiles = new Tile[ROWS][COLS];
    for (int Y = 0; Y < ROWS; Y++) {
      for (int X = 0; X < COLS; X++) {
        Tile tile = new Tile(X, Y);
        tile.TERRAIN = layout[Y][X];
        if (tile.TERRAIN == 3) {
          startTile = tile;
        }
        if (tile.TERRAIN == 4) {
          endTile = tile;
        }
        /*if (tile.TERRAIN == 2) {
         if (mousePressed) {
         //println("change");
         tile.TERRAIN = 5;
         }
         }*/

        
        tiles[Y][X] = tile;
      }
    }
    // TODO: set each tile's neighboring nodes
    for (int Y = 0; Y < ROWS; Y++) {
      for (int X = 0; X < COLS; X++) {
        tiles[Y][X].addNeighbors(new Tile[]{
          getTile(X, Y-1), //Top
          getTile(X+1, Y), //Right
          getTile(X, Y+1), //Bottom
          getTile(X-1, Y) //Left
          });
      }
    }
  }
}