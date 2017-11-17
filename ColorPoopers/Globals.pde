static class Globals {

  static public int DisplayScaleFactor = 8;
  static public float GridRegenerationPercentage = 0.01;
  
  // Bacteria
  static public float BacteriaInitMuHue = 0;//random(TWO_PI);
  static public float BacteriaInitSigmaHue = TWO_PI/8.0;
  static public float BacteriaInitHealth = 1.0;
  static public float BacteriaInitSplitThreshold = 20.0;
  
  static public float BacteriaCostOfLiving = 0.1;
  static public float BacteriaMutationMuHueMag = 0.5;
  static public float BacteriaMutationSigmaHueMag = 0.1;
  static public float BacteriaMutationSplitThreshMag = 0.05;
}