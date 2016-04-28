//OBJECTS
Level level;
Pathfinder pathfinder;
Player enemy;

// declaration types, check the Java API

float timePrev = 0;
float timer = 0;
int lives = 10;
int waveCount = 10;
final int waveConst = 10;
int wavesCompleted = 0;

ArrayList<Tower> towers = new ArrayList <Tower>();
ArrayList<Player> enemies = new ArrayList<Player>();

//OBJECTS

void setup() {
  TileHelper.app = this; 
  size(640, 640);

  level = new Level();
  pathfinder = new Pathfinder();
  enemy = new Player();
  //towers = new ArrayList <Tower>(); 
  /* for (int i = 0; i < 2; i++) {
   enemies.add(new Player());
   }*/
}

void draw() {

  float time = millis()/1000.0;
  float dt = (time - timePrev);
  timePrev = time;
  timer += dt;
  //println(timePrev);
  //println(timer);

  if (waveCount > 0) {
    if (enemies.size() < 20) {
      // for (int i = 0; i <= 5; i++) {
      if (timer >= 2) {
        enemies.add(new Player());
        timer = 0;
        waveCount--;
        println(waveCount);
      }// if end
      //}// for loop end
    }// if end
  }

  if (enemies.size() == 0 && waveCount < 1) {
    wavesCompleted++;
    waveCount = waveConst + wavesCompleted;
  }

  for (int i=0; i<towers.size(); i++) {
    //fill(255);
    //ellipse(gridP.x,gridP.y,28,28);
    towers.get(i).draw();
  }

  Point p = TileHelper.pixelToGrid(new PVector(mouseX, mouseY));//making a new point p and using that to get the grid position of the mouses pixels space equivalent
  Tile tile = level.getTile(p.x, p.y);
  if (tile != null) { //if the tile is not null you can hover over the tile 
    tile.hover = true;
    // draw a little ellipse in the tile's center
    PVector c =  tile.getCenter(); // gets the center of the mouse 
    fill(0);
    ellipse(c.x, c.y, 8, 8);
  }

  //DRAW LOGIC
  background(127);
  level.draw();
  //println(lives);

  for (int i = enemies.size()-1; i >= 0; i--) {
    enemies.get(i).draw();
    enemies.get(i).update();

    if (enemies.get(i).isDead) {
      lives--;
      enemies.remove(i);
    }
  }

  for (int i = towers.size() - 1; i >= 0; i--) {
    towers.get(i).update();
  }
  //END DRAW LOGIC
}


void mousePressed() {

  if (enemies.size() != 0) {
    enemies.get(0).damage();
    println(enemies.get(0).health);
  }
  //enemy.setTargetPosition(p);

  // Tower t = new Tower(p);

  //add tower to array/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //towers.add(new Tower(p));
}