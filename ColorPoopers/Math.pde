static class Math {
  static float SQRT_TWOPI = sqrt(TWO_PI);
  static float normalProb(float x, float sigma) {
    return exp(-x*x/(2*sigma*sigma))/(SQRT_TWOPI*sigma);
  }
  
  static double customProb1(float x, double c) {
    //print("x "+x+",c "+c);
    double outVal = (1.0/(c+1.0+sin(x-PI/2))-1.0/(c+2.0))
                       /
                    (1.0/c-1.0/(c+2.0));
    //println(" = "+outVal);
    return outVal;
  }
}