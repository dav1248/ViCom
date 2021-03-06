 void settings() {
      size(1000, 1000, P2D);
}
void setup () {
}
void draw() {
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 10, 15, 30);
  //interactive matrices
  float[][] scale= scaleMatrix(x,x,x);
  float[][] transform1 = rotateXMatrix(y*PI/8);
  float[][] transform1bis = rotateYMatrix(z*PI/8);
  
  //declaration of the box with the interactive transformations
  input3DBox =transformBox(transformBox(transformBox(input3DBox, transform1),transform1bis),scale);
  projectBox(eye, input3DBox).render();  

  //rotated and translated
  float[][] transform2 = translationMatrix(200, 200, 0);
  input3DBox = transformBox(input3DBox, transform2);
  projectBox(eye, input3DBox).render();
  //rotated, translated, and scaled
  
  float[][] transform3 = scaleMatrix(2,2,2);
  input3DBox = transformBox(input3DBox, transform3);
  projectBox(eye, input3DBox).render();
  

}
float x=10;
float y=0;
float z=0;
void mouseDragged() 
{
 x+=0.2;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      y+=0.1;
    } 
    else if (keyCode == DOWN) {
      y-=0.1;
    } 
    else if (keyCode == LEFT) {
      z-=0.1;
    } 
    else if (keyCode == RIGHT) {
      z+=0.1;
    } 
 }
}




class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
  this.x = x;
  this.y = y; }
}
class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
             this.x = x;
             this.y = y;
             this.z = z;
  } 
}

public float[][] multiply (float[][] A , float[][] B){
  float[][] result = new float[A.length][B[0].length];
  for(int i = 0; i< A.length; i++){
       for(int j = 0; j<B[0].length; j++){
          for(int k = 0; k < B.length; k++){
             result[i][j] += A[i][k] * B[k][j];
          } 
       }
       
    }
    return result;
}


My2DPoint projectPoint(My3DPoint eye, My3DPoint p) { //Complete the code!
  float[][] T = {{1,0,0,-eye.x},{0,1,0,-eye.y},{0,0,1,-eye.z},{0,0,0,1}};
  float[][] P = {{1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,1/-eye.z,0}};
  
  float[][] r = multiply(P,T);
  float[][] sec = {{p.x},{p.y},{p.z},{1}};
  
  float[][] s = multiply(r, sec);
  return new My2DPoint(s[0][0]/s[3][0],s[1][0]/s[3][0]); 
  
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s; 
  }
  
  void render() {
    line(s[0].x, s[0].y, s[1].x, s[1].y);
    line(s[1].x, s[1].y, s[2].x, s[2].y);
    line(s[2].x, s[2].y, s[3].x, s[3].y);
    line(s[3].x, s[3].y, s[0].x, s[0].y);
    line(s[0].x, s[0].y, s[4].x, s[4].y);
    line(s[3].x, s[3].y, s[7].x, s[7].y);
    line(s[1].x, s[1].y, s[5].x, s[5].y);
    line(s[2].x, s[2].y, s[6].x, s[6].y);
    line(s[4].x, s[4].y, s[5].x, s[5].y);
    line(s[5].x, s[5].y, s[6].x, s[6].y);
    line(s[6].x, s[6].y, s[7].x, s[7].y);
    line(s[7].x, s[7].y, s[4].x, s[4].y);
  }


}
class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
  float x = origin.x;
  float y = origin.y;
  float z = origin.z;
  this.p = new My3DPoint[]{
    new My3DPoint(x,y+dimY,z+dimZ),
    new My3DPoint(x,y,z+dimZ),
    new My3DPoint(x+dimX,y,z+dimZ),
    new My3DPoint(x+dimX,y+dimY,z+dimZ),
    new My3DPoint(x,y+dimY,z),
    origin,
    new My3DPoint(x+dimX,y,z),
    new My3DPoint(x+dimX,y+dimY,z)
  }; }
  
  My3DBox(My3DPoint[] p) {
    this.p = p; 
  }
}

float[] homogeneous3DPoint (My3DPoint p) {
      float[] result = {p.x, p.y, p.z , 1};
      return result;
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] my2Dp = new My2DPoint[box.p.length];
  for(int i=0;i<box.p.length;i++){ 
    my2Dp[i] = projectPoint(eye, box.p[i]);
  }
  
  return new My2DBox(my2Dp);
}


  float[][]  rotateXMatrix(float angle) {
      return(new float[][] {{1, 0 , 0 , 0},
                            {0, cos(angle), sin(angle) , 0},
                            {0, -sin(angle) , cos(angle) , 0},
                            {0, 0 , 0 , 1}});
}
float[][] rotateYMatrix(float angle) { 
  return(new float[][] {    {cos(angle), 0 , sin(angle) , 0},
                            {0, 1, 0 , 0},
                            {-sin(angle), 0, cos(angle) , 0},
                            {0, 0  , 0 , 1}});
}
float[][] rotateZMatrix(float angle) { 
      return(new float[][] {{cos(angle), -sin(angle), 0 , 0},
                            {sin(angle), cos(angle), 0 , 0},
                            {0, 0 , 1 , 0},
                            {0, 0 , 0 , 1}});

}
float[][] scaleMatrix(float x, float y, float z) { 
      return(new float[][] {{x, 0, 0 , 0},
                            {0, y, 0 , 0},
                            {0, 0 , z , 0},
                            {0, 0 , 0 , 1}});


}
float[][] translationMatrix(float x, float y, float z) { 
      return(new float[][] {{1, 0, 0 , x},
                            {0, 1, 0 , y},
                            {0, 0 , 1 , z},
                            {0, 0 , 0 , 1}});

}

float[] matrixProduct(float[][] a, float[] b) { 
      float[] res = new float[a.length];
      for( int i=0; i<a.length; i++){
         for (int j=0; j<a[0].length; j++) {
            
              res[i] += a[i][j]*b[j];
           
           
         }
        
      }
      
      return res;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  float help[] = new float[4];
  float vector[] = new float[4];
  My3DPoint point[] = new My3DPoint[8];
  for(int i=0;i<8;i++){
    help[0]=box.p[i].x;
    help[1]=box.p[i].y;
    help[2]=box.p[i].z;
    help[3]=1;
    vector=matrixProduct(transformMatrix,help);
    
    point[i]= euclidian3DPoint(vector);
   
    
  }
  return new My3DBox(point);
}
My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}