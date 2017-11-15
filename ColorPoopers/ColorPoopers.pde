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
  grid.regenerate();

  for (int stepIdx = 0; stepIdx < 1; stepIdx++) {
    colony.step();
    colony.procreate();
    if (frameCount % 100 == 0) println(colony.bacteria.size());
  }
  
  //background(0);
  //grid.show();
  colony.show();
  
}