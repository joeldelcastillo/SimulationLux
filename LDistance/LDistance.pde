import peasy.*;
import processing.serial.*;

Serial myPort;  // The serial port
int nl = 10;

PeasyCam cam;

// setup
int width = 1600;
int height = 900;

PVector[][] globe;
int times = 0;
int total = 19 + 1;
int medios = 5;
float dLeds = 17;
float radius = 150;

float bolbingMax = 1.1;
float xoff = 0;
float phase = 0;
float speed = 0.003;
float colorMutator = 0.04;
int offset = 80;

//Toggle
float c = 1;
boolean rRadious = true;


//Position, Velocity, Accealphaion and Time

float easing = 0.05;
float xmouse;
float ymouse;


PVector prevMousePos = new PVector(mouseX, mouseY);
PVector prevMouseVel = new PVector(0, 0);
PVector gyro = new PVector(0, 0, 0);
float lastTime = 0;
float delta = 0;




void setup() {

  fullScreen("processing.opengl.PGraphics3D");
  cam = new PeasyCam(this, 500);
  colorMode(HSB, TWO_PI);
  globe = new PVector [total][60];

    // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 115200);

  for (int i = 1; i < total; i++) {
    float alpha = map(i, 0, total, 0, PI);
    int numLeds = ceil ((2* PI * radius * sin(alpha))/dLeds);
    println(numLeds);
    PVector arrayLeds[] = new PVector[numLeds];

    for (int j = 0; j < numLeds +1; j++) {
      float beta = map(j, 0, numLeds, 0, 2* PI);
      float x = radius * sin(alpha) * cos(beta);
      float y = radius * sin(alpha) * sin(beta);
      float z = radius * cos(alpha);
      globe[i][j] = new PVector(x, y, z);
    }
  } 
}

void draw() {

  while (myPort.available() > 0) {
    String array = myPort.readStringUntil(nl);
    float[] nums = {0,0,0};
    try   { 
      nums = float(split(array, ','));
        gyro.setX(nums[0]);            
    } 
    catch(NullPointerException e)   { 
        System.out.print("Caught NullPointerException"); 
        gyro.set(0, 0, 0); 
    } 

    background(0);
  stroke(255);
  lights();

  float voly = gyro.x;
  float targetY = voly;
  float dy = targetY - ymouse;
  ymouse += dy * easing;
  
  float volx = gyro.z;
  float targetX = volx;
  float dx = targetX - xmouse;
  xmouse += dx * easing;


  //-------------------------Move main point give mouse
  float newR = radius * 1.4;
  float b = map(ymouse, -180, 180, -4* PI, 4* PI);
  float a = map(xmouse, -180, 180, -4* PI, 4* PI);
  float xm = newR * sin(a) * cos(b);
  float ym = newR * sin(a) * sin(b);
  float zm = newR * cos(a);
  PVector mainPoint = new PVector(xm, ym, zm);


  strokeWeight(20);
  stroke(PI, 255, 255);
  point(mainPoint.x, mainPoint.y, mainPoint.z);


  strokeWeight(5);
  for (int i = 1; i < 19+1; i++) {
    
    float alpha = map(i, 0, total, 0, PI);
    int numLeds = ceil ((2* PI * radius * sin(alpha))/dLeds);
    beginShape(POINTS);
    for (int j = 0; j < numLeds; j++) {
      float beta = map(j, 0, numLeds, 0, 2* PI);
      PVector v1 = globe[i][j];
      

      //--------- Change given movement

      // float xoff = map(sin(alpha) * cos(beta), -1, 1, 0, bolbingMax * velocityY);
      // float yoff = map(sin(alpha) * sin(beta), -1, 1, 0, bolbingMax * velocityY);
      // float zoff = map(cos(alpha), -1, 1, 0, bolbingMax * velocityY);
      // float pNoise = noise(xoff+phase, yoff+phase, zoff+phase);
      // float r = map(pNoise, 0, 1, radius - offset, radius + offset);

      //---------- Change given distance
      
      float distance = PVector.dist(v1, mainPoint);
      float rchange = 1/distance;
      float x = (radius ) * sin(alpha) * cos(beta);
      float y = (radius ) * sin(alpha) * sin(beta);
      float z = (radius ) * cos(alpha);

      float hu = map(distance * 0.2, -150, 150, 0 - PI , TWO_PI + PI);
      stroke(hu, 255, 255);

      globe[i][j] = new PVector(x, y, z);

      //  if(ceil(alpha)%2 == 0){
      //    vertex(v1.x*2, v1.y*2, v1.z*2);
      //  }
      // if (times ==1) println(v1);

      vertex(v1.x, v1.y, v1.z);
    }
    endShape();
  }

  // prevMousePos = mousePos;
  // prevMouseVel = mouseVel;

  }
  
  phase += speed;
  times++;

  //-------------------

  lastTime = millis(); 

}
