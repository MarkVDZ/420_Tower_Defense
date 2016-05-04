

class Player {
  //GRID-SPACE COORDINATES
  Point gridP = new Point(); //grid current position
  Point gridT = new Point(); //grid target position
  //PIXEL-SPACE COODS
  PVector pixlP = new PVector(); //Current pixel position

  ArrayList<Tile> path;
  boolean findPath = true;
  boolean isDead = false;
  boolean isDeadAtTarget = false;
  int health = 10;

  Player() {
    teleportTo(gridP);
  }
  void teleportTo(Point gridP) {
    Tile tile = level.getTile(gridP.x, gridP.y);
    if (tile!=null) {
      this.gridP = gridP.get();
      this.gridT = gridP.get();
      this.pixlP = tile.getCenter();
    }
  }

  void setTargetPosition(Point gridT) {
    //this.gridT = gridT.get();
    this.gridT = gridT.get(); //TileHelper.pixelToGrid(new PVector(, ));
  }

  void update() {
    if (findPath) findPathAndTakeNextStep();
    updateMove();
  }

  void findPathAndTakeNextStep() {
    findPath = false;

    //find path to target grid position
    Tile start = level.getTile(gridP.x, gridP.y);
    //Tile end = level.getTile(gridT.x, gridT.y);
    Tile end = level.getTile(9, 9);

    if (start == end) {
      isDeadAtTarget = true;
      path = null;
      return;
    }

    path = pathfinder.findPath(start, end);

    if (path != null && path.size() > 1) {
      Tile tile = path.get(1);
      if (tile.isPassable()) gridP = new Point(tile.X, tile.Y);
    }
    
  }
  void updateMove() {

    PVector pixlT = level.getTileCenter(gridP);
    PVector diff = PVector.sub(pixlT, pixlP);
    
    int speed = 1;

    //Move towards the target
    //pixlP.x += diff.x*.2;
    //pixlP.y += diff.y*.2;
    // Take the difference (diff) and interpolate the movement
    if(diff.x > 0){
      pixlP.x += speed;
    }
    if(diff.x < 0){
      pixlP.x -= speed;
    }
    if(diff.y > 0){
      pixlP.y += speed;
    }
    if(diff.y < 0){
      pixlP.y -= speed;
    }

    //MAKE SURE THERE ARE NO MOVEMENT BUGS...OR ELSE...
    if (abs(diff.x)<1)pixlP.x = pixlT.x;
    if (abs(diff.y)<1)pixlP.y = pixlT.y;

    //IF WE ARRIVE AT LOCATION, TRIGGER NEXT PATH FIND
    if (pixlP.x == pixlT.x && pixlP.y == pixlT.y) findPath = true;
    
  }

  void draw() {
    noStroke();
    fill(0);
    ellipse(pixlP.x, pixlP.y, 28, 28);
    drawPath();
  }
  void drawPath(){
   if(path != null && path.size() > 1){
     stroke(0);
     PVector prevP = pixlP.get();
     for(int i = 1; i < path.size(); i++){
       PVector nextP  = path.get(i).getCenter();
       line(prevP.x, prevP.y, nextP.x, nextP.y);
       prevP = nextP;
       
     }
     noStroke();
     fill(0);
     ellipse(prevP.x, prevP.y, 8,8);
   }
  }
  
  /*void damage(){
    health--;
    if(health == 0) isDead = true;
  }*/
  
   void hurt() {
    health --;
    fill(255,0,0);
    ellipse(pixlP.x + random(5), pixlP.y + random(5), random(4+2), random(4+2));
    ellipse(pixlP.x - random(5), pixlP.y - random(5), random(4+2), random(4+2));
    ellipse(pixlP.x - random(5), pixlP.y + random(5), random(4+2), random(4+2));
   if (health == 0){
     isDead = true;
     //println(health);
   }
  }
  
  void healthUp(){
    health += 2;
  }
  
}