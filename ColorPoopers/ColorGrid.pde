class ColorGrid {
  ArrayList<ArrayList<ColorGridPoint>> grid;
  int width;
  int height;

  ColorGrid(int _width, int _height) {
    println(_width+"x"+_height);
    this.width = _width;
    this.height = _height;
    grid = new ArrayList<ArrayList<ColorGridPoint>>(this.width);
    for (int x = 0; x < this.width; x++) {
      grid.add(new ArrayList<ColorGridPoint>(this.height));
      for (int y = 0; y < this.height; y++) {
        grid.get(x).add(new ColorGridPoint(1.0f, null));
      }
    }
  }
  
  int wrapX(int x) {
      if (x < 0) x = width-1;
      if (x >= width) x = 0;
      return x;
  }
  
  int wrapY(int y) {
      if (y < 0) y = height-1;
      if (y >= height) y = 0;
      return y;
  }

  void setVal(int x, int y, ColorGridPoint val) {
    grid.get(wrapX(x)).set(wrapY(y), val);
  }

  ColorGridPoint getVal(int x, int y) {
    return grid.get(wrapX(x)).get(wrapY(y));
  }

  void show() {
    for (int x = 0; x < this.width; x++) {
      for (int y = 0; y < this.height; y++) {
        ColorGridPoint p = getVal(x, y);
        fill(color(p.food,p.food,p.food));
        noStroke();
        rect(Globals.DisplayScaleFactor*x, Globals.DisplayScaleFactor*y, Globals.DisplayScaleFactor, Globals.DisplayScaleFactor);
      }
    }
  }
}