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
PVector bubblePointer;
PVector windForce;
PVector gravity;
boolean breakDetector = false;
boolean pressDetector = false;
color backgroundColor;
color backgroundWeatherOverlay;

void setup() {

  //Serial Setup
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 9600); 
  myPort.bufferUntil(lf);

  //Basic Setup
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(60);
  size(1024, 1024);
  
  bubblePointer = new PVector(512,512);
  windForce = new PVector(0, 0);
  gravity = new PVector(0, 1);

  windLevel = 1;
}

void draw() {

  if (inString != null) {
    String[] data = split(trim(inString), ":");
    //printArray(data);
    if (data.length == 5) {

      //Draw Time Background

      int timeMap = int(map(float(data[2]), 0, 4096, 0, 101));
      backgroundColor = color(199, 100, 100 - timeMap);
      background(backgroundColor);
      
      //Draw Sun and Moon
      
      int moonPos = int(map(float(data[2]), 0, 4096, 196, -828));
      fill(42,100,100);
      noStroke();
      circle(moonPos,196,256);
      fill(54,77,100);
      noStroke();
      circle(moonPos+1024,196,256);
      fill(backgroundColor);
      noStroke();
      circle(moonPos+1024+128,196,256);

      //Draw Tree
      
      fill(16,30,55);
      noStroke();
      rect(896,0,128,1024);
      fill(151,56,78);
      noStroke();
      circle(1024,-71,878);
      circle(645,-141,622);
      
      //Draw Weather Overlay

      int weatherMap = int(map(float(data[3]), 0, 4096, -100, 101));
      windForce.x = int(weatherMap / 4);
      windLevel = abs(int(windForce.x)) + 1;
      backgroundWeatherOverlay = color(145, 0, 80 - timeMap * 0.6, abs(weatherMap) * 0.9);
      fill(backgroundWeatherOverlay);
      noStroke();
      square(0, 0, 1024);

      //Add bubble if button pressed

      if (pressDetector == false) {
        if (float(data[4]) == 0) {
          pressDetector = true;
        }
      } else {
        if (float(data[4]) == 1) {
          pressDetector = false;
          allBubbles.add(new Bubble(bubblePointer.x, bubblePointer.y, windLevel));
        }
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

    //Draw bubble blower
    
    int posXMoveMap = int(map(float(data[0]), 0, 4096, 0, 31));
    int posYMoveMap = int(map(float(data[1]), 0, 4096, 0, 31));
    
    print(posXMoveMap);
    print(":");
    print(posYMoveMap);
    print(":");
    print(bubblePointer.x);
    print(":");
    println(bubblePointer.y);
    
    fill(0, 0, 0, 0);
    strokeWeight(6);
    stroke(0, 0, 100);
    
    if (bubblePointer.x + posXMoveMap - 15 <= 23) {
      bubblePointer.x = 23;
    }
    else if (bubblePointer.x + posXMoveMap - 15 >= 1001) {
      bubblePointer.x = 1001;
    }
    else if (bubblePointer.x >= 23 && bubblePointer.x <= 1001) {
      bubblePointer.x += posXMoveMap - 15; 
    }
    
    if (bubblePointer.y + posYMoveMap - 15 <= 23) {
      bubblePointer.y = 23;
    }
    else if (bubblePointer.y + posYMoveMap - 15 >= 1001) {
      bubblePointer.y = 1001;
    }
    else if (bubblePointer.y >= 23 && bubblePointer.y <= 1001) {
      bubblePointer.y += posYMoveMap - 15;
    }
    
    circle(bubblePointer.x, bubblePointer.y, 40);
  }
}

void serialEvent(Serial p) {

  inString = p.readString();
} 
