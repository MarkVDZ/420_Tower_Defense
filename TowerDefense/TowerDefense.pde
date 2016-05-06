import ddf.minim.*;

Minim minim;
AudioPlayer firstTheme;
AudioPlayer secondTheme;
AudioPlayer thirdTheme;
AudioPlayer fourthTheme;
AudioPlayer button;
AudioPlayer loseLife;
AudioPlayer enemyDie;
AudioPlayer playerDie;
AudioPlayer towerPlace;
AudioPlayer badSound;

// Music from www.bensound.com

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
int currentLevel;

ArrayList<Tower2> towers2 = new ArrayList <Tower2>();
ArrayList<Tower> towers = new ArrayList <Tower>();
ArrayList<Player> enemies = new ArrayList<Player>();

boolean sameTowerPlacement = false;
boolean paused = false;

//States Stuff
boolean Title = true;
boolean Play = false;
boolean Lose = false;
boolean setup = true;

//OBJECTS

void setup() {
  TileHelper.app = this; 
  size(640, 640);

  minim = new Minim(this);
  level = new Level();
  pathfinder = new Pathfinder();
  enemy = new Player();

  firstTheme = minim.loadFile("bensound-scifi.mp3");
  secondTheme = minim.loadFile("bensound-house.mp3");
  thirdTheme = minim.loadFile("bensound-ofeliasdream.mp3");
  fourthTheme = minim.loadFile("bensound-epic.mp3");
  loseLife = minim.loadFile("Path end.wav");
  enemyDie = minim.loadFile("Death Sound.mp3");
  playerDie = minim.loadFile("player dies.wav");
  towerPlace = minim.loadFile("tower place.wav");
  button = minim.loadFile("Button Press.mp3");
  badSound = minim.loadFile("Bad place.wav");
  //
  firstTheme.loop();
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
      button.rewind();
      button.play();
      newGame();
    }
  }

  if (Play == true && Lose == false && Title == false) {

    background(127);
    level.draw();

    if (setup == true) {
      textSize(20);
      text("This is the setup phase. When ready, hit space to continue.", 50, 500);

      if (Keys.onDown(Keys.SPACE)) {
        button.rewind();
        button.play(); 
        setup = false;
      }
    }

    if (Keys.onDown(Keys.P)) {
      paused = !paused;
    }
    if (paused) {
      pause();
      //println(paused);
      return;
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
          if (timer >= 2) {
            spawnEnemy();
          }// if end
        }// if end
      }
    }

    if (enemies.size() == 0 && waveCount < 1) {
      switchLevel();
      wavesCompleted++;
      waveCount = waveConst + wavesCompleted;
      currency += 10;
    }

    if (enemies.size() != 0) {
      println(enemies.get(0).health);
    }

    //println(waveCount);
    //println(towers.size());

    for (int i = towers.size()-1; i >= 0; i--) {
      fill(255);
      towers.get(i).draw();
    }
    for (int i = towers2.size()-1; i >= 0; i--) {
      fill(0);
      towers2.get(i).draw();
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
    fill(0);
    text("Waves Completed:  " + wavesCompleted, 400, 100);
    text("Life:  " + lives, 400, 150);
    String money = "Money:" + " " + "$" + nf(currency, 4) ;
    text(money, 400, 50);
    text( "Wall $20", 400, 200); 
    text("Super tower $500",400, 250);
    text("Tower $100",400,300);
    text("Click to place Towers",50,450);
    text("Hold A and click to place Walls", 50, 350); 
    text("Hold D and click to place Super towers",50, 400);  
    switchMusic();

    for (int i = enemies.size()-1; i >= 0; i--) {
      enemies.get(i).draw();
      enemies.get(i).update();

      if (enemies.size() != 0) {
        if (enemies.get(i).isDeadAtTarget) {
          //background(255, 0, 0);
          fill(255, 0, 0);
          rect(0, 0, 640, 640);
          loseLife.rewind();
          loseLife.play();
          lives--;
          enemies.remove(i);
        }
      }

      if (enemies.size() != 0) {
        if (enemies.get(i).isDead) {
          enemyDie.rewind();
          enemyDie.play();
          currency += 10;
          enemies.remove(i);
        }
      }
    }

    for (int i = towers.size() - 1; i >= 0; i--) {
      towers.get(i).update();
      ((Tower)towers.get(i)).shoot();
    }

    for (int i = towers2.size() - 1; i >= 0; i--) {
      towers2.get(i).update();
      ((Tower2)towers2.get(i)).shoot();
    }


    if (lives < 1) {
      switchToLose();
    }

    //END DRAW LOGIC
  }

  if (Lose == true && Play == false) {
    background(127);
    textSize(30);
    fill(0);
    text("You have lost", width/4 + 50, 100);
    text("Waves Completed:  " + wavesCompleted, width/4, 200);
    text("Life:  " + lives, width/4 + 100, 300);
    textSize(20);
    text("Press Space to return to the Main Menu", width/4 - 50, 400);

    if (Keys.onDown(Keys.SPACE)) {
      switchToTitle();
    }
  } // end loseState
} // end draw


void mousePressed() {
  //enemies.get(0).findPathAndTakeNextStep();
  spawnTower();
  spawnWalls();
  spawnTower2();
}

void spawnTower() {
  if (Play == true) {

    Point p = TileHelper.pixelToGrid(new PVector(mouseX, mouseY));

    Tower t = new Tower(p);

    //add tower to array//
    if (currency >= 100) {
      if (!Keys.isDown(Keys.D)) {
        if (!Keys.isDown(Keys.A)) {
          Tile tile = level.getTile(p.x, p.y);
          if (tile == null) return;

          int originalTerrain = tile.TERRAIN;

          level.setTile(p, 5);
          ArrayList<Tile> path = pathfinder.findPath(level.startTile, level.endTile);

          if (path == null) {
            badSound.rewind();
            badSound.play();
            level.setTile(p, originalTerrain);
          } else {
            towerPlace.rewind();
            towerPlace.play();
            towers.add(new Tower(p));
            currency -= 100;
          }
        }
      }
    }
  }
}

void spawnTower2() {
  //when d is held tower 2 can be placed
  if (Play == true) {

    Point p = TileHelper.pixelToGrid(new PVector(mouseX, mouseY));
    if (currency >= 200) {
      if (Keys.isDown(Keys.D)) {
        Tile tile = level.getTile(p.x, p.y);
        if (tile == null) return;

        int originalTerrain = tile.TERRAIN;

        level.setTile(p, 6);
        ArrayList<Tile> path = pathfinder.findPath(level.startTile, level.endTile);

        if (path == null) {
          badSound.rewind();
          badSound.play();
          level.setTile(p, originalTerrain);
        } else {
          towerPlace.rewind();
          towerPlace.play();
          towers2.add(new Tower2(p));
          currency -= 200;
        }
      }
    }
  }
}

void spawnWalls() {
  if (Play == true) {
    Point p = TileHelper.pixelToGrid(new PVector(mouseX, mouseY));
    //enemies.get(0).findPathAndTakeNextStep();
    if (currency >= 20) {
      if (Keys.isDown(Keys.A)) {
        Tile tile = level.getTile(p.x, p.y);
        if (tile == null) return;

        int originalTerrain = tile.TERRAIN;
        level.setTile(p, 2);
        ArrayList<Tile> path = pathfinder.findPath(level.startTile, level.endTile);

        if (path == null) {
          badSound.rewind();
          badSound.play();
          level.setTile(p, originalTerrain);
        } else {
          towerPlace.rewind();
          towerPlace.play();
          currency -= 20;
          //enemies.get(0).findPathAndTakeNextStep();
        } // end if A
      } // end if currency
    } // end if null check
  } // end if play
} // end method


void switchToLose() {
  playerDie.rewind();
  playerDie.play();
  Play = false;
  Lose = true;

  for (int i = towers.size() - 1; i >= 0; i--) {
    towers.remove(i);
  }
  for (int i = enemies.size() - 1; i >= 0; i--) {
    enemies.remove(i);
  }
}

void switchToTitle() {
  button.rewind();
  button.play();
  Lose = false;
  Title = true;
  Play = false;
}

void spawnEnemy() {
  enemies.add(new Player());
  timer = 0;
  waveCount--;
  //println(waveCount);
}

void newGame() {
  Play = true;
  Title = false;
  Lose = false;
  setup = true;
  lives = 10;
  waveCount = waveConst;
  currency = 200;
  level = new Level();
  currentLevel = 1;
}

void switchMusic() {
  if (currentLevel == 2) {
    firstTheme.mute();
    secondTheme.loop();
  }
  if (currentLevel == 3) {
    secondTheme.mute();
    thirdTheme.loop();
  }
  if (currentLevel == 4) {
    thirdTheme.mute();
    fourthTheme.loop();
  }
}

void switchLevel() {
  switch(wavesCompleted) {

  case 7:
    currentLevel = 2;
    level.loadLevel(LevelDefs.LEVEL3);
    for (int i = towers.size() - 1; i >= 0; i--) {
      currency += 100;
      towers.remove(i);
    }
    for (int i = towers2.size() - 1; i >= 0; i--) {
      currency += 200;
      towers2.remove(i);
    }
    setup = true;
    break;
  case 14:
    currentLevel = 3;
    level.loadLevel(LevelDefs.LEVEL4);
    for (int i = towers.size() - 1; i >= 0; i--) {
      currency += 100;
      towers.remove(i);
    }
    for (int i = towers2.size() - 1; i >= 0; i--) {
      currency += 200;
      towers2.remove(i);
    }
    setup = true;
    break;
  case 21:
    currentLevel = 4;
    level.loadLevel(LevelDefs.LEVEL5);
    for (int i = towers.size() - 1; i >= 0; i--) {
      currency += 100;
      towers.remove(i);
    }
    for (int i = towers2.size() - 1; i >= 0; i--) {
      currency += 200;
      towers2.remove(i);
    }
    setup = true;
    break;
  case 28:
    level.loadLevel(LevelDefs.LEVEL1);
    for (int i = towers.size() - 1; i >= 0; i--) {
      currency += 100;
      towers.remove(i);
    }
    for (int i = towers2.size() - 1; i >= 0; i--) {
      currency += 200;
      towers2.remove(i);
    }
    setup = true;
    break;
  default:
    break;
  }
}

void pause() {
  background(0);
  textSize(40);
  fill(255);
  text("PAUSED", width/2 - 75, 100);
  textSize(30);
  text("Press space to return to main menu", 60, 400);
  if (Keys.onDown(Keys.SPACE)) {
    Lose = false;
    Play = false;
    Title = true;
    paused = false;

    for (int i = towers.size() - 1; i >= 0; i--) {
      towers.remove(i);
    }
    for (int i = enemies.size() - 1; i >= 0; i--) {
      enemies.remove(i);
    }
  }
}