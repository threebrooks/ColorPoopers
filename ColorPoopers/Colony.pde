import java.util.*;

class Colony {
  ArrayList<Bacteria> bacteria = new ArrayList<Bacteria>();
  ColorGrid grid = null;

  Colony(int numBac, ColorGrid _grid) {
    grid = _grid;
    for (int bacIdx = 0; bacIdx < numBac; bacIdx++) {
      int x = (int)random(grid.width);
      int y = (int)random(grid.height);
      bacteria.add(new Bacteria(x, y, Globals.BacteriaInitMuHue, Globals.BacteriaInitSigmaHue, Globals.BacteriaInitHealth, Globals.BacteriaInitSplitThreshold, Globals.BacteriaInitMutationMuHueMag));
    }
  }

  void step() {
    //println(bacteria.size());
    for (int bacIdx = 0; bacIdx < bacteria.size(); bacIdx++) {
      Bacteria bac = bacteria.get(bacIdx);
      bac.step(grid, bacIdx == bacteria.size()/2);
    }
  }

  void procreate() {
    int currentSize = bacteria.size();
    //println(currentSize);
    for (int bacIdx = 0; bacIdx < currentSize; bacIdx++) {
      Bacteria bac = bacteria.get(bacIdx);
      Bacteria clone = bac.procreate(grid);
      if (clone != null) bacteria.add(clone);
    }

    ArrayList<Bacteria> deathList = new ArrayList<Bacteria>();
    for (int bacIdx = 0; bacIdx < bacteria.size(); bacIdx++) {
      Bacteria bac = bacteria.get(bacIdx);
      if (bac.health < 0) deathList.add(bac);
    }
    for (Bacteria b : deathList) {
      if (!bacteria.remove(b)) println("WTF");
      ColorGridPoint pointUnderNewBac = grid.getVal(b.x, b.y);
      pointUnderNewBac.occ = false;
    }
  }

  void show() {
    for (int bacIdx = 0; bacIdx < bacteria.size(); bacIdx++) {
      Bacteria bac = bacteria.get(bacIdx);
      bac.show();
    }
  }

  void dumpBacteriaStats() {
    try {
      int res = 100;
      int[] histo = new int[res];
      float totalHealth = 0.0;
      for (int bacIdx = 0; bacIdx < bacteria.size(); bacIdx++) {
        Bacteria bac = bacteria.get(bacIdx);
        histo[(int)(res*bac.muHue/TWO_PI)]++;
        totalHealth += bac.health;
        //println(bacIdx+": x="+bac.x+", y="+bac.y+", h="+bac.health+", mu="+bac.muHue+", sig="+bac.sigmaHue);
      }
      println("T: "+totalHealth/bacteria.size());
      PrintWriter p = new PrintWriter("/tmp/bac.stats");
      for (int idx = 0; idx < res; idx++) {
        p.write(histo[idx]+"\n");
      }
      p.close();
    } 
    catch (Exception e) {
      println(e.getMessage());
    }
  }
}