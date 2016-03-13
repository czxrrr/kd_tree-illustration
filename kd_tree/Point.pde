class Point{
  float x,y; 
  float area;
  boolean inter;
  public Point(float a,float b){
     x=a;
     y=b;
  }
  public float far(float a,float b){
    return sqrt((a-x)*(a-x)+(b-y)*(b-y));
  }

}