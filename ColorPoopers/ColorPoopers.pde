ColorGrid grid = null;
Colony colony = null;

void setup() {

  size(600, 480);
  colorMode(HSB);
  frameRate(100);

  grid = new ColorGrid(width/Globals.DisplayScaleFactor, height/Globals.DisplayScaleFactor);
  colony = new Colony(1, grid);
}

void draw() {

  for (int stepIdx = 0; stepIdx < 10; stepIdx++) {
    grid.regenerate();
    colony.step();
    colony.procreate();
    //if (frameCount % 100 == 0) println(colony.bacteria.size());
  }

  grid.show();
  colony.show();

  if (mousePressed) {
    colony.dumpBacteriaStats();
  }
}