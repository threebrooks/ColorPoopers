import java.util.*;

class Colony {
  ArrayList<Bacteria> bacteria = new ArrayList<Bacteria>();
  ColorGrid grid = null;

  Colony(int numBac, ColorGrid _grid) {
    grid = _grid;
    for (int bacIdx = 0; bacIdx < numBac; bacIdx++) {
      float muHue = 0;//random(TWO_PI);
      float sigmaHue = TWO_PI/16.0;
      int x = (int)random(grid.width/10);
      int y = (int)random(grid.height/10);
      bacteria.add(new Bacteria(x, y, muHue, sigmaHue, 1.0, 100.0));
    }
  }

  void step() {
    //println(bacteria.size());
    for (int bacIdx = 0; bacIdx < bacteria.size(); bacIdx++) {
      Bacteria bac = bacteria.get(bacIdx);
      bac.step(grid);
    }
  }
  
  void procreate() {
    ArrayList<Bacteria> newList = new ArrayList<Bacteria>();
    for (int bacIdx = 0; bacIdx < bacteria.size() ; bacIdx++) {
      Bacteria bac = bacteria.get(bacIdx);
      Bacteria clone = bac.procreate(grid);
      if (clone != null) newList.add(clone);
    }
    for(Bacteria b : newList) {
      bacteria.add(b);
      ColorGridPoint pointUnderNewBac = grid.getVal(b.x, b.y);
      pointUnderNewBac.occ = true;
    }
    
    ArrayList<Bacteria> deathList = new ArrayList<Bacteria>();
    for (int bacIdx = 0; bacIdx < bacteria.size() ; bacIdx++) {
      Bacteria bac = bacteria.get(bacIdx);
      if (bac.health < 0) deathList.add(bac);
    }
    for(Bacteria b : deathList) {
      bacteria.remove(b);
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
}