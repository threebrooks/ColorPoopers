static class Math {
  static float SQRT_TWOPI = sqrt(TWO_PI);
  static float normalProb(float x, float sigma) {
    return exp(-x*x/(2*sigma*sigma))/(SQRT_TWOPI*sigma);
  }
  
  static double customProb1(float x, double c) {
    print("x "+x+",c "+c);
    double invCp1 = 1.0/(c+1.0);
    double invCm1 = 1.0/(c-1.0);
    double outVal = (1.0/(c+1.0+sin(x))-invCp1)/(invCm1-invCp1);
    //println(" = "+outVal);
    return outVal;
  }
}