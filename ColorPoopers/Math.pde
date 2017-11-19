static class Math {
  static float SQRT_TWOPI = sqrt(TWO_PI);
  static float normalProb(float x, float sigma) {
    return exp(-x*x/(2*sigma*sigma))/(SQRT_TWOPI*sigma);
  }
}