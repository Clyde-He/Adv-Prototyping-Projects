import processing.serial.*; 
Serial myPort;    // The serial port
String inString = "";  // Input string from serial port
String sepString = "";
int lf = 10;      // ASCII linefeed

int temperature = 0;
int light = 0;
boolean sound = false;
boolean move = false;

boolean soundPressDetector;
int soundCycleCounter;
boolean movePressDetector;
int moveCycleCounter;

ArrayList<species1> allSpecies1 = new ArrayList<species1>();
int spawnCycle = 160;
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
  frameRate(60);
  size(1280, 720);
  colorMode(HSB, 360, 100, 100, 100);
}

void draw() {

  background(0, 0, 100);

  // Data Parsing
  if (inString != null) {
    String[] data = split(trim(inString), ":");
    // Data -> Temperature -> Range
    temperature = int(map(int(data[0]), 0, 4096, 10, 40));
    species1Range = int(map(temperature, 10, 40, 20, 120));

    // Data -> Light -> Size
    light = int(map(int(data[1]), 0, 4096, 0, 100));
    species1Size = int(map(light, 0, 100, 2, 24));


    if (soundPressDetector == false) {
      if (float(data[2]) == 0) {
        soundPressDetector = true;
        sound = true;
      }
    } else {
      if (float(data[2]) == 1) {
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
        spawnCycle = int(spawnCycle / 3);
        moveCycleCounter = 1;
      }
    }

    //println(str(species1Range) + " " + str(species1Size) + " " + str(sound) + " " + str(move));
  }

  // Spawn New Species 1 into Array
  if (currentCycle == 0 || allSpecies1.size() == 0) {
    //species1(float pSpawnPosX, float pSpawnPosY, int pCurrentSize, int pCurrentSpeed, boolean pIsConnected) {
    allSpecies1.add(new species1(int(random(10, 1270)), int(random(10, 710)), species1Size, species1Speed, false));
  } else if (currentCycle % spawnCycle == 0 && allSpecies1.size() != 0) {
    int tempSpawnIndex = int(random(0, allSpecies1.size()));
    species1 tempSpawnSpecies1 = allSpecies1.get(tempSpawnIndex);
    int tempSpawnPosX = int(random(tempSpawnSpecies1.position.x - species1Range, tempSpawnSpecies1.position.x + species1Range));
    int tempSpawnPosY = int(random(tempSpawnSpecies1.position.y - species1Range, tempSpawnSpecies1.position.y + species1Range));
    allSpecies1.add(new species1(tempSpawnPosX, tempSpawnPosY, species1Size, species1Speed, false));
  }

  // Connect Species 1s
  if (allSpecies1.size() >= 0) {

    //ArrayList<species1> tempAllSpecies1 = new ArrayList<species1>();
    //for (species1 currentSpecies1 : allSpecies1) {
    //  tempAllSpecies1.add(currentSpecies1);
    //}
    //for (species1 currentSpecies1 : allSpecies1) {
    //  for (int index = tempAllSpecies1.size() - 1; index >= 0; index--) {
    //    species1 current2Species1 = tempAllSpecies1.get(index);
    //    if (sqrt(sq(currentSpecies1.position.x - current2Species1.position.x) + sq(currentSpecies1.position.y - current2Species1.position.y)) <= species1Range * 8) {
    //      currentSpecies1.isConnected = true;
    //      line(currentSpecies1.position.x, currentSpecies1.position.y, current2Species1.position.x, current2Species1.position.y);
    //    } else {
    //      currentSpecies1.disconnected();
    //    }
    //  }
    //  tempAllSpecies1.remove(0);
    //}

    for (species1 currentSpecies1 : allSpecies1) {
      for (species1 current2Species1 : allSpecies1) {
        if (sqrt(sq(currentSpecies1.position.x - current2Species1.position.x) + sq(currentSpecies1.position.y - current2Species1.position.y)) <= species1Range * 6) {
          currentSpecies1.isConnected = true;
          strokeWeight(0.5);
          line(currentSpecies1.position.x, currentSpecies1.position.y, current2Species1.position.x, current2Species1.position.y);
        } else {
          currentSpecies1.isConnected = false;
        }
      }
    }
  }

  // Update All Species 1
  if (allSpecies1.size() != 0) {
    for (species1 currentSpecies1 : allSpecies1) {
      currentSpecies1.show();
      currentSpecies1.grow(species1Size);
      currentSpecies1.move(species1Speed, species1Range);
    }
  }

  // Remove Species 1 Outside Screen or Too Small
  for (int index = allSpecies1.size() - 1; index >= 0; index--) {
    species1 tempSpecies1 = allSpecies1.get(index);
    if (tempSpecies1.position.x < 0 || tempSpecies1.position.x > 1280 || tempSpecies1.position.y < 0 || tempSpecies1.position.y > 720 || tempSpecies1.size <= 0) {
      allSpecies1.remove(index);
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
    if (spawnCycle < 120) {
      spawnCycle++;
      moveCycleCounter = 0;
    }
  }
  
  // Debug Data
  textSize(14);
  fill(0,0,0);
  text("Temperature: " + str(temperature), 10, 20);
  text("Light Intensity: " + str(light) + "%", 10, 40);
  text("Detect Sound: " + str(sound), 10, 60);
  text("Detect Movement: " + str(move), 10, 80);

  currentCycle++;
}

void serialEvent(Serial p) {
  inString = p.readString();
} 
