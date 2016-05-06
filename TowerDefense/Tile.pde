static class TileHelper {
  static TowerDefense app;
  final static int W = 32;
  final static int H = 32;
  final static int halfW = W / 2;
  final static int halfH = H / 2;

  // converts from grid coordinates to pixel coordinates
  static PVector gridToPixel(Point p) {
    return new PVector((p.x*W), (p.y*H));
  }
  // converts from pixel coordinates to grid coordinates
  static Point pixelToGrid(PVector p) {
    return app.new Point((int)(p.x/W), (int)(p.y/H));
  }
}

class Tile {
  int X;
  int Y;
  public int TERRAIN = 0;
  boolean hover = false;
  boolean isOn = false;
  //PImage floor = loadImage("Floor.png");
  
  Tower tower;

  Tile(int X, int Y) {
    this.X = X;
    this.Y = Y;
  }
  void update(){
    isOn = false;
  }
  void draw() {  
    if (TERRAIN == 0) fill(127);
    //else if (hover) {}
    //else return;
    if (TERRAIN == 1)fill(200);
    if (TERRAIN == 2)fill(255);
    if (TERRAIN == 3)fill(255, 0, 0);
    if (TERRAIN == 4)fill(0, 255, 0);
    if (TERRAIN == 5)fill(175);
    if (TERRAIN == 6)fill(150);
    
    if (hover) fill(255,255,0);
    rect(X*TileHelper.W, Y*TileHelper.H, TileHelper.W, TileHelper.H);
    hover = false;
  }

  ///RETURNS CENTER OF THE TILE IN PIXEL COORDINATES
  PVector getCenter() {
    PVector p = TileHelper.gridToPixel(new Point(X, Y)); 
    p.x+=TileHelper.halfW;
    p.y+=TileHelper.halfH;
    return p;
  }

  ///////////////////////////////////////////////////////////
  ///////////////PATHFINDING STUFF GOES HERE/////////////////
  ///////////////////////////////////////////////////////////
  ArrayList<Tile> neighbors = new ArrayList<Tile>(); //list of neightboring tiles
  Tile parent; //parent of this tile
  float G; //cost of traveling from start to this tile
  float F; //estimated total cost;

  boolean isPassable() {
    //return TERRAIN != 2;
    if (TERRAIN == 2) return false;
    if(isOn) return false;
    if (TERRAIN == 5)return false;
    if (TERRAIN == 6) return false;
    return true; //if tile is wall or tower enemy cant pass///////////////////////////////////////////////////////////
  }

  void resetParent() {
    parent = null;
    G = 0;
    F = 0;
  }
  void setParent(Tile tile) {
    parent = tile;
    G = parent.G + getTerrainCost();
  }
  float getTerrainCost() {
    if (TERRAIN == 0) return 1;
    if (TERRAIN == 1) return 5;
    if (TERRAIN == 2) return 1000;
    if (TERRAIN == 3) return 1;
    if (TERRAIN == 4) return 1;
    if (TERRAIN == 5) return 1000;
    if (TERRAIN == 6) return 1000;
    return 1000;
  }

  void doHeuristic(Tile end) {
    float H;
    float dx = end.X-X;
    float dy = end.Y-Y;
    H = (abs(dx) + abs(dy));
    F = G + H;
  }

  void addNeighbors(Tile[] tiles) {
    for (Tile t : tiles) {
      if (t != null)neighbors.add(t);
    }
  }
}