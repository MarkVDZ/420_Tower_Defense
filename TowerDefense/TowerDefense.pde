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
int currency = 200;

ArrayList<Tower> towers = new ArrayList <Tower>();
ArrayList<Player> enemies = new ArrayList<Player>();

boolean sameTowerPlacement = false;

//States Stuff
boolean Title = true;
boolean Play = false;
boolean Lose = false;
boolean setup = true;

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
  if (Title) {
    background(127);
    fill(0);
    textSize(40);
    text("420 Blaze'it Defense", CENTER + 100, 100);
    textSize(20);
    text("Press Enter to Play", CENTER + 225, 300);
    if (Keys.onDown(Keys.ENTER)) {
      Play = true;
      Title = false;
      Lose = false;
      setup = true;
    }
  }

  if (Play == true && Lose == false && Title == false) {
    
    background(127);
    level.draw();

    if (setup == true) {
      textSize(20);
      text("This is the setup phase. When ready, hit space to continue.", 50, 500);
      
      if(Keys.onDown(Keys.SPACE)) setup = false;
      
    }
    float time = millis()/1000.0;
    float dt = (time - timePrev);
    timePrev = time;
    timer += dt;
    //println(timePrev);
    //println(timer);
    if (setup == false) {
      if (waveCount > 0) {
        if (enemies.size() < 20) {
          // for (int i = 0; i <= 5; i++) {
          if (timer >= 2) {
            enemies.add(new Player());
            timer = 0;
            waveCount--;
            //println(waveCount);
          }// if end
          //}// for loop end
        }// if end
      }
    }

    if (enemies.size() == 0 && waveCount < 1) {
      wavesCompleted++;
      //enemies.healthUp();
      waveCount = waveConst + wavesCompleted;
    }

    if (enemies.size() != 0) {
      println(enemies.get(0).health);
    }

    

    for (int i = towers.size()-1; i >= 0; i--) {
      fill(255);
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
    //println(lives);

    textSize(20);
    text("Waves Completed:  " + wavesCompleted, 400, 100);
    text("Life:  " + lives, 400, 150);

    for (int i = enemies.size()-1; i >= 0; i--) {
      enemies.get(i).draw();
      enemies.get(i).update();

      if (enemies.size() != 0) {
        if (enemies.get(i).isDeadAtTarget) {
          lives--;
          enemies.remove(i);
        }
      }

      if (enemies.size() != 0) {
        if (enemies.get(i).isDead) {
          currency += 10;
          enemies.remove(i);
        }
      }
    }

    for (int i = towers.size() - 1; i >= 0; i--) {
      towers.get(i).update();
      ((Tower)towers.get(i)).shoot();
    }

    if (lives < 1) {
      Play = false;
      Lose = true;

      for (int i = towers.size() - 1; i >= 0; i--) {
        towers.remove(0);
      }
      for (int i = enemies.size() - 1; i >= 0; i--) {
        enemies.remove(0);
      }
      
    }
    //END DRAW LOGIC
  }

  if (Lose == true && Play == false) {
    background(127);
    textSize(30);
    text("You have lost", width/4 + 50, 100);
    text("Waves Completed:  " + wavesCompleted, width/4 - 50, 200);
    text("Life:  " + lives, width/4 + 100, 300);
    textSize(20);
    text("Press Space to return to the Main Menu", width/4 - 100, 400);

    if (Keys.onDown(Keys.SPACE)) {
      Lose = false;
      Title = true;
      Play = false;
      lives = 10;
    }
  } // end loseState
} // end draw


void mousePressed() {
  Point p = TileHelper.pixelToGrid(new PVector(mouseX, mouseY));

  enemy.setTargetPosition(p);

  Tower t = new Tower(p);

  //add tower to array//

  towers.add(new Tower(p));
  level.setTile(p, 5);

  /*if (enemies.size() != 0) {
   enemies.get(0).damage();
   println(enemies.get(0).health);
   }*/
}