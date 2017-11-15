static class Angle {
  static public float minDist(float a, float b) {
    float dist = a-b;
    if (dist >= PI) dist -= TWO_PI;
    if (dist <= -PI) dist += TWO_PI;
    return abs(dist);
  }
  
  static public float opposite(float a) {
    return limit(a+PI);
  }
  
  static public float limit(float v) {
    if (v >= TWO_PI) v -= TWO_PI;
    if (v <= 0) v += TWO_PI;
    return v;
  }
}