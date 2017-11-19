ColorGrid grid = null;
Colony colony = null;
boolean showColony = false;

void setup() {

  size(600, 480);
  colorMode(HSB);
  frameRate(100);

  grid = new ColorGrid(width/Globals.DisplayScaleFactor, height/Globals.DisplayScaleFactor);
  colony = new Colony(1, grid);
}

void draw() {

  for (int stepIdx = 0; stepIdx < 1; stepIdx++) {
    grid.regenerate();
    colony.step();
    colony.procreate();
    //if (frameCount % 100 == 0) println(colony.bacteria.size());
  }

  clear();
  if (showColony) {
    colony.show();
  } else {
     grid.show(); 
  }

  if (mousePressed) {
    colony.dumpBacteriaStats();
    showColony = !showColony;
  }
  //println(frameRate);
}