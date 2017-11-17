float radianToHue(float h) {
  return 255*(h/TWO_PI);
}

float magToBrightness(float m) {
  return 255*m;
}

class Bacteria {
  float muHue;
  float sigmaHue;
  float muHueMutationMag;

  int x;
  int y;

  float health;
  float splitThreshold;

  Bacteria(int _x, int _y, float _muHue, float _sigmaHue, float _health, float _splitThreshold, float _muHueMutationMag) {
    x = _x;
    y = _y;
    muHue = _muHue;
    sigmaHue = _sigmaHue;
    health = _health;
    splitThreshold = _splitThreshold;
    muHueMutationMag = _muHueMutationMag;
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
    health -= Globals.BacteriaCostOfLiving;

    float underMeHueDist = Angle.minDist(pointUnderMe.hue, muHue);
    float underMeEatProb = exp(-underMeHueDist*underMeHueDist/sigmaHue);
    float nibble = underMeEatProb*pointUnderMe.mag;
    health += nibble;
    pointUnderMe.mag -= nibble;

    // New hue is essentially a mixture of old and poop
    float poopColor = Angle.opposite(muHue);
    pointUnderMe.hue  = Angle.limit(pointUnderMe.hue+underMeEatProb*Angle.minDist(poopColor, pointUnderMe.hue));

    ArrayList<DirHelper> possibleDirections = new ArrayList<DirHelper>();
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        ColorGridPoint p = grid.getVal(x+dx, y+dy);
        if (p.occ && (!(dx == 0 && dy == 0))) continue;
        float hueDist = Angle.minDist(p.hue, muHue);
        float hueProb = exp(-hueDist*hueDist/sigmaHue);
        float prob = hueProb*p.mag;

        if (dx == 1) prob *= 1000;

        DirHelper dirH = new DirHelper();
        dirH.dx = dx;
        dirH.dy = dy;
        dirH.prob = prob;

        //println(dx+","+dy+": p.hue "+p.hue+", hueDist "+hueDist+", hueProb "+hueProb+", p.mag "+p.mag+", dirH.prob "+dirH.prob);

        possibleDirections.add(dirH);
      }
    }

    //if (debug) println(possibleDirections.size());

    if (possibleDirections.size() > 0) {
      DirHelper bestDir = chooseFromDirHelpers(possibleDirections);

      ColorGridPoint oldP = grid.getVal(x, y);
      oldP.occ = false;

      x = grid.wrapX(x+bestDir.dx);
      y = grid.wrapY(y+bestDir.dy);

      ColorGridPoint newP = grid.getVal(x, y);
      newP.occ = true;
    }
  }

  Bacteria procreate(ColorGrid grid) {
    if (health < splitThreshold) return null;

    ArrayList<DirHelper> possibleDirections = new ArrayList<DirHelper>();
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        ColorGridPoint p = grid.getVal(x+dx, y+dy);
        if (p.occ) continue;

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
      Angle.limit(muHue+random(-muHueMutationMag, muHueMutationMag)), 
      sigmaHue*(1.0+random(-Globals.BacteriaMutationSigmaHueMag, Globals.BacteriaMutationSigmaHueMag)), 
      health, 
      splitThreshold+random(-Globals.BacteriaMutationSplitThreshMag, Globals.BacteriaMutationSplitThreshMag), 
      muHueMutationMag*(1.0+random(-Globals.BacteriaMutationSquaredMuHueMag, Globals.BacteriaMutationSquaredMuHueMag)));

    ColorGridPoint p = grid.getVal(newBac.x, newBac.y);
    p.occ = true;

    return newBac;
  }

  void show() {
    fill(color(radianToHue(muHue), 255, 255));
    noStroke();
    rect(Globals.DisplayScaleFactor*x, Globals.DisplayScaleFactor*y, Globals.DisplayScaleFactor, Globals.DisplayScaleFactor);
  }
}