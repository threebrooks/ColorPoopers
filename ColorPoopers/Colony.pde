import java.util.*;

class Colony {
  ColorGrid grid = null;

  Colony(int numBac, ColorGrid _grid) {
    grid = _grid;
    for (int bacIdx = 0; bacIdx < numBac; bacIdx++) {
      int x = (int)random(grid.width);
      int y = (int)random(grid.height);
      grid.getVal(x,y).occ = new Bacteria(x, y, grid.getVal(x,y).food);
    }
  }

  void step() {
    //println(bacteria.size());
    float avgHealth = 0.0f;
    int numBac = 0;
    for (int x = 0; x < grid.width; x++) {
      for (int y = 0; y < grid.height; y++) {
        Bacteria bac = grid.getVal(x,y).occ;
        if (bac == null) continue;
        bac.step(grid, false);
        avgHealth += bac.health;
        numBac++;
      }
    }
    avgHealth /= numBac;
    println(avgHealth);
  }

  void procreate() {
    ArrayList<Bacteria> newBacs = new ArrayList<Bacteria>();
    for (int x = 0; x < grid.width; x++) {
      for (int y = 0; y < grid.height; y++) {
        Bacteria bac = grid.getVal(x,y).occ;
        if (bac == null) continue;
        Bacteria newBac = bac.procreate(grid);
        if (newBac != null) {
          newBacs.add(newBac);
        }
      }
    }
    for(int idx = 0; idx < newBacs.size(); idx++) {
      Bacteria bac = newBacs.get(idx);
      grid.getVal(bac.x, bac.y).occ=  bac;
    }
  }

  void show() {
    for (int x = 0; x < grid.width; x++) {
      for (int y = 0; y < grid.height; y++) {
        Bacteria bac = grid.getVal(x,y).occ;
        if (bac == null) continue;
        bac.show();
      }
    }
  }
}