float radianToHue(float h) {
  return 255*(h/TWO_PI);
}

float magToBrightness(float m) {
  return 255*m;
}

class Bacteria {
  float muHue;
  float sigmaHue;

  int x;
  int y;

  float health;
  float splitThreshold;

  Bacteria(int _x, int _y, float _muHue, float _sigmaHue, float _health, float _splitThreshold) {
    x = _x;
    y = _y;
    muHue = _muHue;
    sigmaHue = _sigmaHue;
    health = _health;
    splitThreshold = _splitThreshold;
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

  public void step(ColorGrid grid) {
    //println("x:" + x +",y "+y);

    ColorGridPoint pointUnderMe = grid.getVal(x, y);
    health -= Globals.CostOfLiving;
    float nibble = Globals.EatPercentage*pointUnderMe.mag;
    health += nibble;
    pointUnderMe.mag -= nibble;
    float poopColor = Angle.opposite(muHue);

    ArrayList<DirHelper> possibleDirections = new ArrayList<DirHelper>();
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        ColorGridPoint p = grid.getVal(x+dx, y+dy);
        if (p.occ && (!(dx == 0 && dy == 0))) continue;
        float hueDist = Angle.minDist(p.hue, muHue);
        float hueProb = exp(-hueDist*hueDist/sigmaHue);
        float prob = hueProb*p.mag;

        DirHelper dirH = new DirHelper();
        dirH.dx = dx;
        dirH.dy = dy;
        dirH.prob = prob;
        
        //println(dx+","+dy+": p.hue "+p.hue+", hueDist "+hueDist+", hueProb "+hueProb+", p.mag "+p.mag+", dirH.prob "+dirH.prob);

        possibleDirections.add(dirH);
      }
    }
    
    //println(bestDirections.size());

    if (possibleDirections.size() > 0) {
      DirHelper bestDir = chooseFromDirHelpers(possibleDirections);
      
      ColorGridPoint oldP = grid.getVal(x, y);
      oldP.occ = false;

      x = grid.wrapX(x+bestDir.dx);
      y = grid.wrapY(y+bestDir.dy);
      
      health += bestDir.prob;
      
      ColorGridPoint newP = grid.getVal(x, y);
      newP.occ = true;
    }

    // println("angle:" + accumAngle +", dx "+nextDx+", dy "+nextDy);
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
      x+bestDir.dx, 
      y+bestDir.dy, 
      Angle.limit(muHue+random(-Globals.MutationMuHueMag, Globals.MutationMuHueMag)), 
      sigmaHue,
      health, 
      splitThreshold+random(-Globals.MutationSplitThreshMag, Globals.MutationSplitThreshMag));
      
    return newBac;
  }

  void show() {
    fill(color(radianToHue(muHue), 255, 255));
    noStroke();
    rect(Globals.DisplayScaleFactor*x, Globals.DisplayScaleFactor*y, Globals.DisplayScaleFactor, Globals.DisplayScaleFactor);
  }
}