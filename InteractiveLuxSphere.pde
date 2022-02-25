import peasy.*;
import processing.sound.*;

PeasyCam cam;
AudioIn input;
Amplitude analyzer;
// setup
int width = 1600;
int height = 900;

PVector[][] globe;
int times = 0;
int total = 80 + 1;
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
float c;
boolean rRadious = true;


//Position, Velocity, Accelation and Time

float easing = 0.05;
float xmouse;
float ymouse;


PVector prevMousePos = new PVector(mouseX, mouseY);
PVector prevMouseVel = new PVector(0, 0);
float lastTime = 0;
float delta = 0;


void setup() {

  fullScreen("processing.opengl.PGraphics3D");
  cam = new PeasyCam(this, 500);
  input = new AudioIn(this, 0);
  input.start();
  analyzer = new Amplitude(this);
  analyzer.input(input);
  colorMode(HSB, TWO_PI);
  globe = new PVector [total][100];

  for (int i = 1; i < total; i++) {
    float lat = map(i, 0, total, 0, PI);
    int numLeds = ceil ((2* PI * radius * sin(lat))/dLeds);
    println(numLeds);
    PVector arrayLeds[] = new PVector[numLeds];

    for (int j = 0; j < numLeds +1; j++) {
      float lon = map(j, 0, numLeds, 0, 2* PI);
      float x = radius * sin(lat) * cos(lon);
      float y = radius * sin(lat) * sin(lon);
      float z = radius * cos(lat);
      globe[i][j] = new PVector(x, y, z);
    }
  } 
}

void draw() {
  background(0);
  stroke(255);
  lights();
  strokeWeight(5);
  float vol = 0 + analyzer.analyze() * 10;
  // stroke(0);
  // fill(0);
  // sphere(140);
  // stroke(0);
  // delta = (millis() - lastTime)* 0.001f;
  // PVector mousePos = new PVector(mouseX, mouseY);
  // PVector mouseVel = mousePos.sub(prevMousePos).div(delta);
  // PVector mouseAcc = mouseVel.sub(prevMouseVel).div(delta);
  // float mouse = map(mouseAcc.mag(), 0, 10, 0, 1);
  // float mouse = map (abs (mouseX-pmouseX)/ delta, 0, width, 0, 10);
  // print(delta + "\n");
  // mouseVel = mousePos.sub

    // float targetX = mouseX;
    // float dx = targetX - xmouse;
    // xmouse += dx * easing;
    
    // float targetY = mouseY;
    // float dy = targetY - ymouse;
    // ymouse += dy * easing;

    // float velocityY;
    // velocityY = (ymouse - prevMousePos.y)* 0.05;
    // prevMousePos.x = xmouse;
    // prevMousePos.y = ymouse;

    // float mouse1 = map(ymouse, 0, height, 0, 2);
    // float mouse2 = map(xmouse, 0, width, 0, 2);




    
    float targetY = vol;
    float dy = targetY - ymouse;
    ymouse += dy * easing;

    // float velocityY;
    // velocityY = (ymouse - prevMousePos.y)* 0.05;
    // prevMousePos.x = xmouse;
    // prevMousePos.y = ymouse;

    // float mouse1 = map(ymouse, 0, height, 0, 2);
    // float mouse2 = map(xmouse, 0, width, 0, 2);

  for (int i = 1; i < total+1; i++) {
    
    float lat = map(i, 0, total, 0, PI);
    int numLeds = ceil ((2* PI * radius * sin(lat))/dLeds);
    beginShape(POINTS);
    for (int j = 0; j < numLeds; j++) {
      float lon = map(j, 0, numLeds, 0, 2* PI);
      PVector v1 = globe[i][j];

      float xoff = map(sin(lat) * cos(lon), -1, 1, 0, bolbingMax * ymouse);
      float yoff = map(sin(lat) * sin(lon), -1, 1, 0, bolbingMax * ymouse);
      float zoff = map(cos(lat), -1, 1, 0, bolbingMax * ymouse);
      float pNoise = noise(xoff+phase, yoff+phase, zoff+phase);
      float r = map(pNoise, 0, 1, radius - offset, radius + offset);

      int k;

      if(c==0){
        k = 1;
      }else{
        k = 0;
      }
      float x = (c*r + radius*k) * sin(lat) * cos(lon);
      float y = (c*r + radius*k) * sin(lat) * sin(lon);
      float z = (c*r + radius*k) * cos(lat);

      // float x = 150 * sin(lat) * cos(lon);
      // float y = 150 * sin(lat) * sin(lon);
      // float z = 150 * cos(lat);

      // Color with Perlin noise
      // float cNoise = noise(phase + colorMutator * v1.x, phase + colorMutator * v1.y, phase +colorMutator * v1.z);
      // float hu = map(cNoise, 0, 1, 0, 45 - redShift);
      // float hu = map(cNoise, 0.8, 1, 0, 255);
      // stroke(random(255), random(255), random(255));
      // stroke(redShift,255, 255);
      
      float hu = map(r, 150 - offset, 150 + offset, 0 - PI/2 , TWO_PI + PI/2);
      stroke(hu, 255, 255);

      globe[i][j] = new PVector(x, y, z);




      //  if(ceil(lat)%2 == 0){
      //    vertex(v1.x*2, v1.y*2, v1.z*2);
      //  }
      // if (times ==1) println(v1);

      vertex(v1.x, v1.y, v1.z);
    }
    endShape();
  }
  phase += speed;
  times++;

  cam.rotateX(0.002);
  cam.rotateY(0.001);
  //-------------------

  lastTime = millis(); 
  // prevMousePos = mousePos;
  // prevMouseVel = mouseVel;


}


void mouseClicked(){
  rRadious =! rRadious;
  if (rRadious){
    c = 0;
  }else{
    c = 1;
  }

}
