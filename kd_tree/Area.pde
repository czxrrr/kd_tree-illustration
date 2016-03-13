class Area{
  float a,b,c,d;//area de medimaybe not exit if it was leaf node)
  float xmin,xmax,ymin,ymax; // this area
  int number;  // ID
  int parent; //parent ID
  int lchild; // child ID
  int rchild;
  boolean hasline;
  int point1;// if it's hasline value is 0 ,then it has either one or two points
  int point2;
  //int deep;
  boolean checked;
  //int link_point;
  Area(float a,float b,float c, float d,int number,float xmin,float xmax,float ymin,float ymax,boolean has){
    this.a=a;
    this.b=b;
    this.c=c;
    this.d=d;
    this.number=number;
    this.xmin=xmin;
    this.xmax=xmax;
    this.ymin=ymin;
    this.ymax=ymax;
    this.hasline=has;
  }
  Boolean contains(float x,float y){
      if(xmin<=x && x<xmax && ymin<=y && y<ymax){
        return true;
      }
      else{
        return false;
      }
  }
  Boolean intersect(float x,float y, float dist){
   if(x<xmin && y<ymin){
     return ((x-xmin)*(x-xmin)+(y-ymin)*(y-ymin)<dist*dist);
   }//1
   if(xmin<x && x<xmax && y<ymin){
     return (y-ymin)*(y-ymin)<dist*dist;
   }//2
   if(x<xmax && y<ymin){
      return ((x-xmax)*(x-xmax)+(y-ymin)*(y-ymin)<dist*dist);
   }//3
   if(x<xmin && ymin<y && y<ymax){ 
     return (x-xmin)*(x-xmin)<dist*dist;
   }
   //4
   if(xmin<x && x<xmax && ymin<y && y<ymax){
     return true;
   }//5
   if(x>xmax && ymin<y && y<ymax){
     return (x-xmax)*(x-xmax)<dist*dist;
   }
   //6
   if(x<xmin && y>ymax){
       return ((x-xmin)*(x-xmin)+(y-ymax)*(y-ymax)<dist*dist);
   }//7
   if(xmin<x && x<xmax && y>ymax){
     return (y-ymax)*(y-ymax)<dist*dist;
   }
   //8
   if(x>xmax && y>ymax){
        return ((x-xmin)*(x-xmin)+(y-ymax)*(y-ymax)<dist*dist);
   }//9
   return false; 
  }
  
}