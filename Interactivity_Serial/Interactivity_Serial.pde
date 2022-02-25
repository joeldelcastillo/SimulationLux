import processing.serial.*;

Serial myPort;  // The serial port
int nl = 10;
PVector gyro = new PVector(0, 0, 0);

void setup() {
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0],115200);
}

void draw() {
  while (myPort.available() > 0) {
    String array = myPort.readStringUntil(nl);
    float[] nums = float(split(array, ','));
    gyro.set(nums[0],nums[1],nums[2] );
    println(gyro);
  }
}
