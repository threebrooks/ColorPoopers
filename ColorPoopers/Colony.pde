import java.util.*;

class Colony {
  ArrayList<Bacteria> bacteria = new ArrayList<Bacteria>();
  ColorGrid grid = null;

  Colony(int numBac, ColorGrid _grid) {
    grid = _grid;
    for (int bacIdx = 0; bacIdx < numBac; bacIdx++) {
      int x = (int)random(grid.width);
      int y = (int)random(grid.height);
      Mutator hueMutator = new Mutator(MutatorType.Angle, Globals.BacteriaInitHue, Globals.BacteriaInitHueROM, Globals.BacteriaInitHueROROM);
      Mutator foodSelectMutator = new Mutator(MutatorType.ZeroToInfinity, Globals.BacteriaInitFoodSelect, Globals.BacteriaInitFoodSelectROM, Globals.BacteriaInitFoodSelectROROM);
      Mutator splitThreshMutator = new Mutator(MutatorType.ZeroToInfinity, Globals.BacteriaInitSplitThreshold, Globals.BacteriaInitSplitThresholdROM, Globals.BacteriaInitSplitThresholdROROM);
      Mutator directionMutator = new Mutator(MutatorType.Angle, Globals.BacteriaInitDir, Globals.BacteriaInitDirROM, Globals.BacteriaInitDirROROM);
      bacteria.add(new Bacteria(x, y, hueMutator, foodSelectMutator, Globals.BacteriaInitHealth, splitThreshMutator, directionMutator));
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
      bacteria.remove(b);
      ColorGridPoint pointUnderNewBac = grid.getVal(b.x, b.y);
      pointUnderNewBac.occ = null;
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
      float avgHealth = 0.0;
      float avgFoodSelectivity = 0.0;
      float avgSplitThresh = 0.0;
      for (int bacIdx = 0; bacIdx < bacteria.size(); bacIdx++) {
        Bacteria bac = bacteria.get(bacIdx);
        histo[(int)(res*bac.hue.val/TWO_PI)]++;
        avgHealth += bac.health;
        avgFoodSelectivity += bac.hueFoodSelectivity.val;
        avgSplitThresh += bac.splitThreshold.val;
      }
      avgHealth /= bacteria.size();
      avgFoodSelectivity /= bacteria.size();
      avgSplitThresh /= bacteria.size();
      println("#bac: "+bacteria.size()+", avg health: "+avgHealth+", avg foodselect "+avgFoodSelectivity+", avg split "+avgSplitThresh);
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