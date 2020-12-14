import processing.serial.*; 
Serial myPort;    // The serial port
String inString = "";  // Input string from serial port
String sepString = "";
int lf = 10;      // ASCII linefeed

PGraphics layer1;

int temperature = 0;
int light = 0;
boolean sound = false;
boolean move = false;

boolean soundPressDetector;
int soundCycleCounter;
boolean movePressDetector;
int moveCycleCounter;

ArrayList<species1> allSpecies1 = new ArrayList<species1>();
ArrayList<species2> allSpecies2 = new ArrayList<species2>();
ArrayList<attractor> allAttractors = new ArrayList<attractor>();
ArrayList<attractor2> allAttractors2 = new ArrayList<attractor2>();
int spawnCycle = 90;
int currentCycle = 0;

int species1Size = 0;
float species1Speed = 1;
int species1Range = 0;

void setup() {

  // Serial Setup
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 9600); 
  myPort.bufferUntil(lf);

  // Basic Setup
  frameRate(30);
  size(1280, 720);
  colorMode(HSB, 360, 100, 100, 100);
  background(0, 0, 50);

  layer1 = createGraphics(width, height);

  // Add Attractor
  allAttractors.add(new attractor(640, 360, species1Speed));
  allAttractors2.add(new attractor2(640, 360, species1Speed));
}

void draw() {
  background(0, 0, 50);
  // Data Parsing
  if (inString != null) {
    String[] data = split(trim(inString), ":");
    // Data -> Temperature -> Range
    temperature = int(map(int(data[0]), 0, 4096, -10, 125));
    species1Range = int(map(temperature, 10, 40, 20, 120));

    // Data -> Light -> Size
    light = int(map(int(data[1]), 0, 4096, 0, 100));
    species1Size = int(map(light, 0, 100, 2, 24));


    if (soundPressDetector == false) {
      if (float(data[2]) == 1) {
        soundPressDetector = true;
        sound = true;
      }
    } else {
      if (float(data[2]) == 0) {
        soundPressDetector = false;
        sound = false;
        species1Speed = species1Speed * 4;
        soundCycleCounter = 1;
      }
    }

    if (movePressDetector == false) {
      if (float(data[3]) == 0) {
        movePressDetector = true;
        move = true;
      }
    } else {
      if (float(data[3]) == 1) {
        movePressDetector = false;
        move = false;
        if (spawnCycle >= 1) {
        spawnCycle = int(spawnCycle / 3);
        moveCycleCounter = 1;
        }
      }
    }
  }

  // Spawn New Species 1 into Array
  if (currentCycle == 0 || allSpecies1.size() == 0) {
    int tempSpawnX = int(random(10, 1270));
    int tempSpawnY = int(random(10, 710));
    allSpecies1.add(new species1(tempSpawnX, tempSpawnY, species1Size, species1Speed, false));
    allSpecies1.add(new species1(tempSpawnX, tempSpawnY, species1Size, species1Speed, false));
  } else if (currentCycle % spawnCycle == 0 && allSpecies1.size() != 0) {
    int tempSpawnIndex = int(random(0, allSpecies1.size()));
    species1 tempSpawnSpecies1 = allSpecies1.get(tempSpawnIndex);
    allSpecies1.add(new species1(tempSpawnSpecies1.position.x, tempSpawnSpecies1.position.y, species1Size, species1Speed, false));
  }

  if (currentCycle == 0 || allSpecies2.size() == 0) {
    int tempSpawnX = int(random(10, 1270));
    int tempSpawnY = int(random(10, 710));
    allSpecies2.add(new species2(tempSpawnX, tempSpawnY, species1Size, species1Speed, false));
    allSpecies2.add(new species2(tempSpawnX, tempSpawnY, species1Size, species1Speed, false));
  } else if (currentCycle % spawnCycle == 0 && allSpecies2.size() != 0) {
    int tempSpawnIndex = int(random(0, allSpecies2.size()));
    species2 tempSpawnSpecies2 = allSpecies2.get(tempSpawnIndex);
    allSpecies2.add(new species2(tempSpawnSpecies2.position.x, tempSpawnSpecies2.position.y, species1Size, species1Speed, false));
  }

  // Connect Species 1s
  if (allSpecies1.size() >= 0) {
    ArrayList<species1> tempAllSpecies1 = (ArrayList<species1>)allSpecies1.clone();
    int connectCounter = 0;

    for (int index1 = 0; index1 < allSpecies1.size(); index1++) {
      allSpecies1.get(index1).disconnected();

      for (int index2 = 0; index2 < tempAllSpecies1.size(); index2++) {
        if (allSpecies1.get(index1).position.x - tempAllSpecies1.get(index2).position.x == 0 && allSpecies1.get(index1).position.y - tempAllSpecies1.get(index2).position.y == 0) {
          continue;
        } else {
          if (sqrt(sq(allSpecies1.get(index1).position.x - tempAllSpecies1.get(index2).position.x) + sq(allSpecies1.get(index1).position.y - tempAllSpecies1.get(index2).position.y)) <= sqrt(species1Range) * 18) {
            connectCounter++;
            if (connectCounter >= 5) {
              continue;
            }
            if (currentCycle % 1 == 0) {
              layer1.beginDraw();
              layer1.colorMode(HSB, 360, 100, 100, 100);
              layer1.stroke(0, 0, 100, 1);
              layer1.strokeWeight(0.1);
              layer1.line(allSpecies1.get(index1).position.x, allSpecies1.get(index1).position.y, tempAllSpecies1.get(index2).position.x, tempAllSpecies1.get(index2).position.y);
              layer1.endDraw();
            }
          }
        }
      }

      image(layer1, 0, 0);

      connectCounter = 0;
    }
  }


  if (allSpecies2.size() >= 0) {
    ArrayList<species2> tempAllSpecies2 = (ArrayList<species2>)allSpecies2.clone();
    int connectCounter = 0;

    for (int index1 = 0; index1 < allSpecies2.size(); index1++) {
      allSpecies2.get(index1).disconnected();

      for (int index2 = 0; index2 < tempAllSpecies2.size(); index2++) {
        if (allSpecies2.get(index1).position.x - tempAllSpecies2.get(index2).position.x == 0 && allSpecies2.get(index1).position.y - tempAllSpecies2.get(index2).position.y == 0) {
          continue;
        } else {
          if (sqrt(sq(allSpecies2.get(index1).position.x - tempAllSpecies2.get(index2).position.x) + sq(allSpecies2.get(index1).position.y - tempAllSpecies2.get(index2).position.y)) <= sqrt(species1Range) * 18) {
            connectCounter++;
            if (connectCounter >= 5) {
              continue;
            }
            if (currentCycle % 1 == 0) {
              layer1.beginDraw();
              layer1.colorMode(HSB, 360, 100, 100, 100);
              layer1.stroke(0, 0, 0, 1);
              layer1.strokeWeight(0.1);
              layer1.line(allSpecies2.get(index1).position.x, allSpecies2.get(index1).position.y, tempAllSpecies2.get(index2).position.x, tempAllSpecies2.get(index2).position.y);
              layer1.endDraw();
            }
          }
        }
      }
      
    //  if (currentCycle % 30 == 0) {
      
    //  layer1.beginDraw();
    //  layer1.colorMode(HSB, 360, 100, 100, 100);
    //  layer1.fill(0, 0, 50, 10);
    //  layer1.noStroke();
    //  layer1.rect(0, 0, 1280, 720);
    //  layer1.endDraw();
      
    //}

      image(layer1, 0, 0);

      connectCounter = 0;
    }
  }

  if (allSpecies1.size() >= 0) {
    ArrayList<species1> tempAllSpecies1 = (ArrayList<species1>)allSpecies1.clone();
    int connectCounter = 0;

    for (int i = 0; i < allSpecies1.size(); i++) {
      for (int j = 0; j < tempAllSpecies1.size(); j++) {
        if (allSpecies1.get(i).position.x - tempAllSpecies1.get(j).position.x == 0 && allSpecies1.get(i).position.y - tempAllSpecies1.get(j).position.y == 0) {
          continue;
        } else {
          if (sqrt(sq(allSpecies1.get(i).position.x - tempAllSpecies1.get(j).position.x) + sq(allSpecies1.get(i).position.y - tempAllSpecies1.get(j).position.y)) <= sqrt(species1Range) * 18) {
            if (connectCounter >= 5) {
              continue;
            }
            stroke(0, 0, 100);
            strokeWeight(2);
            line(allSpecies1.get(i).position.x, allSpecies1.get(i).position.y, tempAllSpecies1.get(j).position.x, tempAllSpecies1.get(j).position.y);
            allSpecies1.get(i).connected();
          }
        }
      }
      connectCounter = 0;
    }
  }

  if (allSpecies2.size() >= 0) {
    ArrayList<species2> tempAllSpecies2 = (ArrayList<species2>)allSpecies2.clone();
    int connectCounter = 0;

    for (int i = 0; i < allSpecies2.size(); i++) {
      allSpecies2.get(i).disconnected();

      for (int j = 0; j < tempAllSpecies2.size(); j++) {
        if (allSpecies2.get(i).position.x - tempAllSpecies2.get(j).position.x == 0 && allSpecies2.get(i).position.y - tempAllSpecies2.get(j).position.y == 0) {
          continue;
        } else {
          if (sqrt(sq(allSpecies2.get(i).position.x - tempAllSpecies2.get(j).position.x) + sq(allSpecies2.get(i).position.y - tempAllSpecies2.get(j).position.y)) <= sqrt(species1Range) * 18) {
            if (connectCounter >= 5) {
              continue;
            }
            stroke(0, 0, 0);
            strokeWeight(2);
            line(allSpecies2.get(i).position.x, allSpecies2.get(i).position.y, tempAllSpecies2.get(j).position.x, tempAllSpecies2.get(j).position.y);
            allSpecies2.get(i).connected();
          }
        }
      }
      connectCounter = 0;
    }
  }



  // Update All Species 1 & Attractor
  if (allSpecies1.size() != 0) {
    for (species1 currentSpecies1 : allSpecies1) {
      currentSpecies1.show();
      currentSpecies1.grow(species1Size);
      for (attractor currentAttractor : allAttractors) {
        currentSpecies1.move(currentAttractor.position, species1Speed, species1Range);
      }
    }
  }

  if (allSpecies2.size() != 0) {
    for (species2 currentSpecies2 : allSpecies2) {
      currentSpecies2.show();
      currentSpecies2.grow(species1Size);
      for (attractor2 currentAttractor2 : allAttractors2) {
        currentSpecies2.move(currentAttractor2.position, species1Speed, species1Range);
      }
    }
  }

  if (allAttractors.size() != 0) {
    for (attractor currentAttractor : allAttractors) {
      //currentAttractor.show();
      currentAttractor.move(species1Speed, species1Range);
    }
  }

  if (allAttractors2.size() != 0) {
    for (attractor2 currentAttractor2 : allAttractors2) {
      //currentAttractor.show();
      currentAttractor2.move(species1Speed, species1Range);
    }
  }


  //Remove Attractor or Species 1 Too Small
  for (int index = allSpecies1.size() - 1; index >= 0; index--) {
    species1 tempSpecies1 = allSpecies1.get(index);
    if (tempSpecies1.size <= 0) {
      allSpecies1.remove(index);
    }
  }

  for (int index = allSpecies2.size() - 1; index >= 0; index--) {
    species2 tempSpecies2 = allSpecies2.get(index);
    if (tempSpecies2.size <= 0) {
      allSpecies2.remove(index);
    }
  }

  for (int index = allAttractors.size() - 1; index >= 0; index--) {
    attractor tempAttractor = allAttractors.get(index);
    if (tempAttractor.position.x < 0 || tempAttractor.position.x > 1280 || tempAttractor.position.y < 0 || tempAttractor.position.y > 720) {
      allAttractors.remove(index);
      allAttractors.add(new attractor(640, 360, species1Speed));
    }
  }

  for (int index = allAttractors2.size() - 1; index >= 0; index--) {
    attractor2 tempAttractor2 = allAttractors2.get(index);
    if (tempAttractor2.position.x < 0 || tempAttractor2.position.x > 1280 || tempAttractor2.position.y < 0 || tempAttractor2.position.y > 720) {
      allAttractors2.remove(index);
      allAttractors2.add(new attractor2(640, 360, species1Speed));
    }
  }

  // Spawn & Move Speed Restore
  if (soundCycleCounter != 0 && soundCycleCounter != 120) {
    soundCycleCounter++;
  } else {
    if (species1Speed > 1) {
      species1Speed -= 0.25;
      soundCycleCounter = 0;
    }
  }

  if (moveCycleCounter != 0 && moveCycleCounter != 120) {
    moveCycleCounter++;
  } else {
    if (spawnCycle < 60) {
      spawnCycle++;
      moveCycleCounter = 0;
    }
  }

  // Debug Data
  //textSize(14);
  //fill(0, 0, 0);
  //text("Temperature: " + str(temperature), 10, 20);
  //text("Light Intensity: " + str(light) + "%", 10, 40);
  //text("Detect Sound: " + str(sound), 10, 60);
  //text("Detect Movement: " + str(move), 10, 80);

  currentCycle++;
}

void serialEvent(Serial p) {
  inString = p.readString();
} 
