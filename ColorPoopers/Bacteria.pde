float radianToHue(float h) {
  return 255*(h/TWO_PI);
}

float magToBrightness(float m) {
  return 255*m;
}

class Bacteria {
  Mutator hue;
  Mutator hueFoodSelectivity;
  Mutator splitThreshold;
  Mutator preferredDirection;

  int x;
  int y;

  float health;

  Bacteria(int _x, int _y, Mutator _hue, Mutator _hueFoodSelectivity, float _health, Mutator _splitThreshold, Mutator _preferredDirection) {
    x = _x;
    y = _y;
    hue = _hue;
    hueFoodSelectivity = _hueFoodSelectivity;
    health = _health;
    splitThreshold = _splitThreshold;
    preferredDirection = _preferredDirection;
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
    return h.get(h.size()-1);
  }

  public void step(ColorGrid grid, boolean debug) {
    //println("x:" + x +",y "+y);

    ColorGridPoint pointUnderMe = grid.getVal(x, y);

    float underMeHueDist = Angle.minDist(pointUnderMe.hue, hue.val);
    float underMeEatProb = (float)Math.customProb1(underMeHueDist,hueFoodSelectivity.val);
    
    float nibble = underMeEatProb*pointUnderMe.mag;
    health += nibble;
    pointUnderMe.mag -= nibble;

    // New hue is essentially a mixture of old and poop
    float poopColor = Angle.opposite(hue.val);
    pointUnderMe.hue  = poopColor;//Angle.limit(pointUnderMe.hue+nibble*Angle.minDist(poopColor, pointUnderMe.hue));

    ArrayList<DirHelper> possibleDirections = new ArrayList<DirHelper>();
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        ColorGridPoint p = grid.getVal(x+dx, y+dy);
        if (p.occ != null && (!(dx == 0 && dy == 0))) continue;
        float hueDist = Angle.minDist(p.hue, hue.val);
        float hueProb = (float)Math.customProb1(hueDist, hueFoodSelectivity.val);
        float angle = (dx == 0 && dy == 0) ? preferredDirection.val : atan2(dy,dx);
        float angleDist = Angle.minDist(angle, preferredDirection.val);
        float directionProb = (float)Math.customProb1(angleDist, Globals.BacteriaDirectionSelectivity);
               
        float prob = hueProb*p.mag*directionProb;

        //if (dx == 1) prob *= 1000;

        DirHelper dirH = new DirHelper();
        dirH.dx = dx;
        dirH.dy = dy;
        dirH.prob = prob;

        //println(dx+","+dy+": p.hue "+p.hue+", hueDist "+hueDist+", hueProb "+hueProb+", p.mag "+p.mag+", dirH.prob "+dirH.prob);

        possibleDirections.add(dirH);
      }
    }
    
    health -= Globals.BacteriaCostOfLiving;

    //if (debug) println(possibleDirections.size());

    if (possibleDirections.size() > 0) {
      DirHelper bestDir = chooseFromDirHelpers(possibleDirections);

      ColorGridPoint oldP = grid.getVal(x, y);
      oldP.occ = null;

      x = grid.wrapX(x+bestDir.dx);
      y = grid.wrapY(y+bestDir.dy);

      ColorGridPoint newP = grid.getVal(x, y);
      newP.occ = this;
    }
  }

  Bacteria procreate(ColorGrid grid) {
    if (health < splitThreshold.val) return null;

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

    // Split
    health /= 2;

    Bacteria newBac = new Bacteria(
      grid.wrapX(x+bestDir.dx), 
      grid.wrapY(y+bestDir.dy), 
      hue.clone(), 
      hueFoodSelectivity.clone(), 
      health, 
      splitThreshold.clone(),
      preferredDirection.clone());
    newBac.mutate();

    ColorGridPoint p = grid.getVal(newBac.x, newBac.y);
    p.occ = newBac;

    return newBac;
  }
  
  void mutate() {
    hue.mutate();
    hueFoodSelectivity.mutate();
    splitThreshold.mutate();
    preferredDirection.mutate();
  }

  void show() {
    fill(color(radianToHue(hue.val), 255, 255));
    noStroke();
    rect(Globals.DisplayScaleFactor*x, Globals.DisplayScaleFactor*y, Globals.DisplayScaleFactor, Globals.DisplayScaleFactor);
  }
}