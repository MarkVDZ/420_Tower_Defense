


class Bullet {
  
  Point gridP = new Point(); //grid current position
  Point gridT = new Point(); //grid target position
  //PIXEL-SPACE COODS
  PVector pixlP = new PVector(); //Current pixel position

  Tower t;
  
  PVector loc = new PVector();//location
  int time = 0;
  PVector center;
  PVector turret;
  //PVector direction;//direction x and direction y
  //PImage bullets;

Bullet (Point gridP){
 Tile tile = level.getTile(gridP.x, gridP.y);
 turret = new PVector(gridP.x, gridP.y);
 //bullet = loadImage("");

}

  void run(Point gridP ) {
    //direction.x = gridP.x;
    //direction.y = gridP.y;
    center = new PVector(gridP.x, gridP.y);//center of turret
    //image(bullet,level.getTile(gridP.x, gridP.y));
    PVector velocity = PVector.sub(center,turret);//speed of bullet
    loc.add(new PVector(velocity.x/2, velocity.y/2));//speed it is traveling
  }


}