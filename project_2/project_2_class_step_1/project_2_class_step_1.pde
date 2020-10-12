import processing.serial.*; 

Serial myPort;    // The serial port
String inString = "";  // Input string from serial port
String sepString = "";
int lf = 10;      // ASCII linefeed 

void setup() { 
  size(800, 800); 
  // You'll need to make this font with the Create Font Tool 
  // List all the available serial ports: 
  printArray(Serial.list()); 
  // I know that the first port in the serial list on my mac 
  // is always my  Keyspan adaptor, so I open Serial.list()[0]. 
  // Open whatever port is the one you're using. 
  myPort = new Serial(this, Serial.list()[1], 9600); 
  myPort.bufferUntil(lf);
  background(0);
} 

void draw() { 

  sepString = inString.substring(0, 3);
  println(float(inString.substring(4)));

  if (sepString.equals("knb")) {
    float rad = map(float(inString.substring(4)), 0, 4096, 0, width);
    background(0);
    fill(255, 0, 0);
    circle(width/2, height/2, rad);
  }
  else if (sepString.equals("btn")) {
    if (float(inString.substring(4)) < 1) { 
      background(255);
    }
  }
  else {
    println("???");
  }
} 

void serialEvent(Serial p) { 
  inString = p.readString();
}
