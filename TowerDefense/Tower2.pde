class Tower2 {

   ArrayList T;//tower
  
  // GRID-SPACE COORDINATES:
  Point gridP = new Point(); // current position
  Point gridT = new Point(); // target position (pathfinding goal)

  // PIXEL-SPACE COORDINATES:
  PVector pixlP = new PVector(); // current pixel position

 
  ArrayList bullets;//bullets
  PVector location = new PVector();
  float r = 40;
  float aX = r;
  float aY = r;
  int radius = 100;
  int Tfr = 0;//tower fire rate
  int inReach = 200;
  //PImage towers;
  float towerX, towerY;


  float angle;

//  void setTargetPosition(Point gridT) {
//    this.gridT = gridT.get();


Tower2(Point Start){
      teleportTo(Start);
      T = new ArrayList(); 
      bullets = new ArrayList();
    }
void teleportTo(Point gridP) {
    Tile tile = level.getTile(gridP.x, gridP.y);
    if (tile != null) {
      this.gridP = gridP.get();
      this.gridT = gridP.get();
      this.pixlP = tile.getCenter();
    }
}
    
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 void shoot() {

    fill(255, 0, 0, 20);
    ellipse(pixlP.x, pixlP.y, (inReach * 2) , (inReach * 2)); 
    if (enemies.size()>0) {//if enemies in the array is greater then 0
    // println (dist((enemies.get(0)).pixlP.x, (enemies.get(0)).pixlP.y, pixlP.x, pixlP.y) + " distance");
      if (dist((enemies.get(0)).pixlP.x, (enemies.get(0)).pixlP.y, pixlP.x, pixlP.y) < inReach) {
        Tfr++;//fire
        if (Tfr == 10) {//if fire rate is = 10 cooldown(the larger the number the the longer it will take to fire again)
          enemies.get(0).hurt();
          Tfr = 0;//reset fire rate
        }
      }
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
  void update() {
    Tile tile =  level.getTile (X, Y);
      tile.isOn = true;
      //tile.TERRAIN = 6;

  }

  void draw() {
    noStroke();
    fill(255, 255, 0);
    ellipse(pixlP.x, pixlP.y, 30, 30);
  }
}