public enum MutatorType {
  Angle,
  ZeroToInfinity
}

class Mutator {

  MutatorType mType;
  float val;
  float ROM;
  float ROROM;

  Mutator(MutatorType type, float initVal, float initROM, float _ROROM) {
    mType = type;
    val = initVal;
    ROM = initROM;
    ROROM = _ROROM;
  }

  void mutate() {
    if (mType == MutatorType.Angle) {
      val = Angle.limit(val+random(-ROM, ROM));
      ROM *= 1.0+random(-ROROM, ROROM);
    }
    else if (mType == MutatorType.ZeroToInfinity) {
      val *= 1.0+random(-ROM, ROM);
      ROM *= 1.0+random(-ROROM, ROROM);
      ROM = min(0.99, ROM);
    }
  }
  
  Mutator clone() {
    return new Mutator(mType, val, ROM, ROROM);
  }
}