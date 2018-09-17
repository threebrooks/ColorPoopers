ColorGrid grid = null;
Colony colony = null;
boolean showColony = true;

void setup() {

  size(600, 480);
  colorMode(RGB);
  frameRate(10);

  grid = new ColorGrid(width/Globals.DisplayScaleFactor, height/Globals.DisplayScaleFactor);
  colony = new Colony(1, grid);
}

void draw() {

  for (int stepIdx = 0; stepIdx < 1; stepIdx++) {
    colony.step();
    colony.procreate();
    //if (frameCount % 100 == 0) println(colony.bacteria.size());
  }

  clear();
  
  grid.show();
  
  if (showColony) {
    colony.show();
  } 

  if (mousePressed) {
    showColony = !showColony;
  }
  //println(frameRate);
}