import processing.serial.*; 
Serial myPort;    // The serial port
String inString = "";  // Input string from serial port
String sepString = "";
int lf = 10;      // ASCII linefeed 

ArrayList<Bubble> allBubbles = new ArrayList<Bubble>();
ArrayList<Bubble> restBubbles = new ArrayList<Bubble>();
ArrayList<Leaf> allLeaves = new ArrayList<Leaf>();
int leafShowFrequency = 0;
int leafShowFrequencyCounter = 0;
int windLevel;
PVector windForce;
PVector gravity;
boolean breakDetector = false;
color backgroundColor;

void setup() {

  //Serial Setup
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600); 
  myPort.bufferUntil(lf);

  //Basic Setup
  colorMode(HSB, 360, 100, 100);
  frameRate(60);
  size(1024, 1024);

  windForce = new PVector(0, 0);
  gravity = new PVector(0, 1);

  windLevel = 1;
}

void draw() {

  sepString = inString.substring(0, 3);

  if (sepString.equals("knb")) {
    int knbMap = int(map(float(inString.substring(4)), 0, 4096, -100, 101));
    windForce.x = int(knbMap / 4);
    windLevel = abs(int(windForce.x)) + 1;
    backgroundColor = color(198, 50, 100 - abs(knbMap));
    background(backgroundColor);
    println(knbMap);
  } else if (sepString.equals("btn")) {
    if (float(inString.substring(4)) < 1) { 
      allBubbles.add(new Bubble(random(1024), random(1024), windLevel));
    }
  }

  //Add leaf at a interval
  
  if (leafShowFrequency == 0) {
    leafShowFrequency = int(random(30, 180) / (windLevel));
  } else {
    leafShowFrequencyCounter += 1;
  }

  if (leafShowFrequencyCounter == leafShowFrequency) {
    allLeaves.add(new Leaf());
    leafShowFrequency = 0;
    leafShowFrequencyCounter = 0;
  }

  //Draw & update leaf
  
  if (allLeaves.size() != 0) {

    for (Leaf currentLeaf : allLeaves) {

      currentLeaf.applyWind(windForce);
      currentLeaf.applyGravity(gravity);
      currentLeaf.show();
      currentLeaf.move();
    }
  }

  //Remove outside leaf from array
  
  for (int index = allLeaves.size() - 1; index >= 0; index--) {
    Leaf tempLeaf = allLeaves.get(index);
    if (tempLeaf.gone()) {
      allLeaves.remove(index);
    }
  }

  //Draw & update bubble

  if (allBubbles.size() != 0) {

    for (Bubble currentBubble : allBubbles) {
      currentBubble.show();
      currentBubble.move();
      currentBubble.applyWind(windForce);
    }

    //Remove booped bubble from array

    for (Bubble readBubble : allBubbles) {
      restBubbles.add(readBubble);
    }

    for (int index = allBubbles.size() - 1; index >= 0; index--) {
      Bubble currentBubble = allBubbles.get(index);

      for (Leaf currentLeaf : allLeaves) {
        if (dist(currentBubble.position.x, currentBubble.position.y, currentLeaf.position.x, currentLeaf.position.y) < currentBubble.size / 2) {
          allBubbles.remove(index);
        }
      }

      if (restBubbles.size() > 0) {
        restBubbles.remove(index);
        for (int index2 = restBubbles.size() - 1; index2 >= 0; index2--) {
          Bubble comparingBubble = restBubbles.get(index2);
          if (dist(currentBubble.position.x, currentBubble.position.y, comparingBubble.position.x, comparingBubble.position.y) < (currentBubble.size + comparingBubble.size) / 2) {
            allBubbles.remove(index);
            allBubbles.remove(index2);
            breakDetector = true;
          }
        }
      }

      if (currentBubble.boop()) {
        allBubbles.remove(index);
      }

      if (breakDetector == true) {
        break;
      }
    }

    restBubbles = new ArrayList<Bubble>();
    breakDetector = false;
  }
}

//void mouseClicked() {
//  allBubbles.add(new Bubble(mouseX, mouseY, windLevel));
//}

//void keyPressed() {
//  if (keyCode == LEFT) {
//    windForce.x -= 1;
//    if (windForce.x >= 0) {
//      windLevel -= 1;
//    } else {
//      windLevel += 1;
//    }
//  } else if (keyCode == RIGHT) {
//    windForce.x += 1;
//    if (windForce.x <= 0) {
//      windLevel -= 1;
//    } else {
//      windLevel += 1;
//    }
//  }

//  println(windLevel);
//  println(windForce);
//  backgroundColor = color(128 / (1 + ((windLevel -1)  * 0.25)), 216 / (1+((windLevel -1) * 0.25)), 255 / (1+((windLevel -1) * 0.25)));
//}

void serialEvent(Serial p) { 
  inString = p.readString();
} 
