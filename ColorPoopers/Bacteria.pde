float magToBrightness(float m) {
  return 255*m;
}

class Bacteria {
  int x;
  int y;

  float health;

  Bacteria(int _x, int _y, float _health) {
    x = _x;
    y = _y;
    health = _health;
  }

  public void step(ColorGrid grid, boolean debug) {
    ColorGridPoint pointUnderMe = grid.getVal(x, y);
 
    float nibble = pointUnderMe.food*Globals.BacteriaEatFactor;
    health += nibble-Globals.BacteriaCostOfLiving;
    pointUnderMe.food -= nibble;
    
    health -= Globals.BacteriaCostOfLiving;
    
    if (health < 0) pointUnderMe.occ = null;
  }
  
  class DirHelper {
   int dx;
    int dy;
    float prob;
  }

  DirHelper chooseFromDirHelpers(ArrayList<DirHelper> h) {
    float totalProb = 0;
    for (int idx = 0; idx < h.size(); idx++) {
      DirHelper d = h.get(idx);
      totalProb += d.prob;
    }
    float chosenProb = random(0, totalProb);
    float accumProb = 0;
    for (int idx = 0; idx < h.size(); idx++) {
      DirHelper d = h.get(idx);
      accumProb += d.prob;
      if (accumProb > chosenProb) return h.get(idx);
    }
    println("$$$$");
    return h.get(h.size()-1);
  }

  Bacteria procreate(ColorGrid grid) {
    ArrayList<DirHelper> possibleDirections = new ArrayList<DirHelper>();
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        ColorGridPoint p = grid.getVal(x+dx, y+dy);
        if (p.occ != null) continue;

        DirHelper dirH = new DirHelper();
        dirH.dx = dx;
        dirH.dy = dy;
        dirH.prob = 1.0;
        possibleDirections.add(dirH);
      }
    }

    if (possibleDirections.size() == 0) return null;

    DirHelper bestDir = chooseFromDirHelpers(possibleDirections);

    Bacteria newBac = new Bacteria(
      grid.wrapX(x+bestDir.dx), 
      grid.wrapY(y+bestDir.dy), 
      0.0f);

    ColorGridPoint p = grid.getVal(newBac.x, newBac.y);
    //p.occ = newBac;

    return newBac;
  }
  

  void show() {
    fill(255, 0, 0);
    noStroke();
    rect(Globals.DisplayScaleFactor*x, Globals.DisplayScaleFactor*y, Globals.DisplayScaleFactor, Globals.DisplayScaleFactor);
  }
}