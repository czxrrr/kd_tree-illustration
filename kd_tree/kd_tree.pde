int width=600;
int height=600;
int index;
int n;
Point[] point;
int stage;
Area[] area;
int area_num;
int keyarea;
float qx,qy;
int ring_num;
float min_dist;
int frame;
//stage 0  generate the points;
//stage 1 sort by the x value and by the y value
//stage 2 generate the kd-tree
//stage 3 find the nearest neighbor

void setup(){
  size(600,600);
  frameRate(9000);
  background(255,255,255);
  fill(0,0,0);
  stroke(0,0,0);
  n=104;
  area_num=0;
  point=new Point[10000];
  area=new Area[1000000];
  index=0;
  stage=0;
  qx=136;
  qy=199;
  frame=1000000;
  
}
 
 
void draw(){
   int i,j;
   if(stage==0){
     for(i=1;i<=index;i++){
       rect(point[i].x,point[i].y,3,3);
     }
     if(index<n){
       index++;
       point[index]=new Point(random(600),random(600));
     }else{
       splitx(1,n,0,0,width,0,height);
       stage=1;
       index=1;
       //println(area_num);
     }
   }
   else if(stage==1){
     if(index<=area_num){
       for(j=1;j<=index;j++){
         if(area[j].hasline){
         line(area[j].a,area[j].b,area[j].c,area[j].d);
         }
       }
       index++;
     }else{
       stage=3;
       index=0;
     }

   }
   else if(stage==3){
    query(qx,qy);
    stage++;
   }
   else{   

    println("key ",keyarea);
    min_dist=999999;
    drawrings(qx,qy,keyarea);
    draw_point_line();   
    noLoop();
    println(ring_num,"bye bye");
   }
   //else{
   //  noLoop();
   //}
   //saveFrame("build/"+str(frame)+".png");
   //frame++;
}   

void draw_point_line(){
  int i,j;
  fill(0,155,255);
  stroke(0,155,255);
  rect(qx,qy,3,3);
  fill(0);
  stroke(0);
  for(i=1;i<n;i++){
    if(point[i].inter){
      stroke(255,100,100);
      fill(255,100,100);
    }
    rect(point[i].x,point[i].y,3,3);
    fill(0);
    stroke(0);
  }
  for(j=1;j<=area_num;j++){
   if(area[j].hasline){
    line(area[j].a,area[j].b,area[j].c,area[j].d);
   }
 }
}

//judge sons, if both sons were checked, then jump to the father, and the father 
//will check it's brother. untill a father cannot jump to the other son.
//if a son's arrange satisfy the min_dist, the father can jump to it
void drawrings(float x, float y, int node){
  Area temp=area[node];
  Point r=new Point(0,0);
  float dist=min_dist;
  temp.checked=true;//once come in ,it will be set checked
  println(node); 
  if(temp.hasline==false){// no children
    if(point[temp.point1].far(x,y)<dist){
      dist=point[temp.point1].far(x,y); 
      r=point[temp.point1];
    }
    //println(point[temp.point1].x,point[temp.point1].y,x,y);
    if(area[node].point2!=0){
      if(point[temp.point2].far(x,y)<dist){
        dist=point[temp.point2].far(x,y); 
        r=point[temp.point2];
      }
    }
    if(dist<min_dist){
      println(dist);
      min_dist=dist;
      fill(200-ring_num*45,255,255);
      stroke(200,150,255);
      ellipse(x,y,min_dist*2,min_dist*2);
      fill(255,200,250);
      stroke(255,200,250);
      r.inter=true;
      //rect(r.x,r.y,5,5);
      ring_num++;
      draw_point_line();   
     }
  }
  else{
    if(area[temp.lchild].intersect(x,y,dist)==false){
      area[temp.lchild].checked=true;  
    }
    if(area[temp.rchild].intersect(x,y,dist)==false){
      area[temp.rchild].checked=true;     
    }
    if(area[temp.lchild].checked==false){
      drawrings(x,y,temp.lchild);
    }  
    if(area[temp.rchild].checked==false){
      drawrings(x,y,temp.rchild);
    }

  }
  if(temp.parent>0) {
    drawrings(x,y,temp.parent);
  }
  //whatever condition it is,the parent will be checked
  
}

void query(float x,float y){ //log(N) find the node,from root to leaf
  fill(180,255,255);
  tint(255, 127);
  ellipse(x,y,6,6);
  int root=1;
  keyarea=find(x,y,root);
  println(keyarea);
}

int find(float x,float y,int node){
  if(area[node].hasline!=true){
    return node;
  }else{
    if(area[area[node].lchild].contains(x,y)){
      return find(x,y,area[node].lchild);
    }else{
      return find(x,y,area[node].rchild);
    }
  }
}

public int splitx(int l,int r,int deep,float xmin,float xmax,float ymin,float ymax){
int i,j,m;
  float mid;
  Point temp;
  int tempNum;
  if(l+1==r || l==r){
    area_num++;
    area[area_num]=new Area(0,0,0,0,area_num,xmin,xmax,ymin,ymax,false);
    area[area_num].point1=l;
    area[area_num].point2=r;
    //if(l!=r){area[area_num].point2=r;}else{area[area_num].point2=0;}
    for(i=l;i<=r;i++){
      point[i].area=area_num;
    }
    return area_num;
  }
  if(l>r){println("error!!"); return 0;}

  for(i=l;i<=r-1;i++){
    for(j=i+1;j<=r;j++){
      if(point[i].x>point[j].x){
        temp=point[i];
        point[i]=point[j];
        point[j]=temp;
      }
    }
  }//don't ignore the condition of l==r
  if((l+r)%2==0){
    mid=point[(l+r)/2].x;
    m=(l+r)/2;

    area_num++;
    area[area_num]=new Area(mid,ymin,mid,ymax,area_num,xmin,xmax,ymin,ymax,true);
    tempNum=area_num;
    area[tempNum].lchild=splity(l,m-1,deep+1,xmin,mid,ymin,ymax);
    area[tempNum].rchild=splity(m,r,deep+1,mid,xmax,ymin,ymax);

  }else{
    m=int((l+r)/2.0-0.5);
    mid=point[m].x;
    mid=mid+point[m+1].x;
    mid=mid/2.0;
    area_num++;
    area[area_num]=new Area(mid,ymin,mid,ymax,area_num,xmin,xmax,ymin,ymax,true);
    tempNum=area_num;
    area[tempNum].lchild=splity(l,m,deep+1,xmin,mid,ymin,ymax);
    area[tempNum].rchild=splity(m+1,r,deep+1,mid,xmax,ymin,ymax);
  }
  if(area[tempNum].lchild>0){area[area[tempNum].lchild].parent=tempNum;} 
  if(area[tempNum].rchild>0){area[area[tempNum].rchild].parent=tempNum;}
  
  return area[tempNum].number; 
 
}

public int splity(int l,int r,int deep,float xmin,float xmax,float ymin,float ymax){
  int i,j,m;
  float mid;
  Point temp;
  int tempNum;
  if(l+1==r || l==r){
    area_num++;
    area[area_num]=new Area(0,0,0,0,area_num,xmin,xmax,ymin,ymax,false);
    area[area_num].point1=l;
    area[area_num].point2=r;
    //if(l!=r){area[area_num].point2=r;}else{area[area_num].point2=0;}
    for(i=l;i<=r;i++){
      point[i].area=area_num;
    }
    return area_num;
  }
  if(l>r){println("error!!"); return 0;}

  for(i=l;i<=r-1;i++){
    for(j=i+1;j<=r;j++){
      if(point[i].y>point[j].y){
        temp=point[i];
        point[i]=point[j];
        point[j]=temp;
      }
    }
  }//don't ignore the condition of l==r
  if((l+r)%2==0){
    mid=point[(l+r)/2].y;
    m=(l+r)/2;
    area_num++;
    area[area_num]=new Area(xmin,mid,xmax,mid,area_num,xmin,xmax,ymin,ymax,true);
    tempNum=area_num;
    area[tempNum].lchild=splitx(l,m-1,deep+1,xmin,xmax,ymin,mid);
    area[tempNum].rchild=splitx(m,r,deep+1,xmin,xmax,mid,ymax);

  }else{
    m=int((l+r)/2.0-0.5);
    mid=point[m].y;
    mid=mid+point[m+1].y;
    mid=mid/2.0;

    area_num++;
    area[area_num]=new Area(xmin,mid,xmax,mid,area_num,xmin,xmax,ymin,ymax,true);
    tempNum=area_num;
    area[tempNum].lchild=splitx(l,m,deep+1,xmin,xmax,ymin,mid);
    area[tempNum].rchild=splitx(m+1,r,deep+1,xmin,xmax,mid,ymax);
  }
  if(area[tempNum].lchild>0){area[area[tempNum].lchild].parent=tempNum;}
  if(area[tempNum].rchild>0){area[area[tempNum].rchild].parent=tempNum;}
  return area[tempNum].number; 
}