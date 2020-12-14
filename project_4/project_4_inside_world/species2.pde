class species2 {
  PVector position = new PVector();
  PVector velocity = new PVector(random(-1, 1), random(-1, 1));
  PVector acceleration = new PVector();
  float size;

  PVector nextPosition = new PVector(0, 0);
  int moveCycleCount = 0;

  int currentSize;
  float currentSpeed;

  boolean isConnected;

  species2(float pSpawnPosX, float pSpawnPosY, int pCurrentSize, float pCurrentSpeed, boolean pIsConnected) {
    position.x = pSpawnPosX;
    position.y = pSpawnPosY;
    currentSize = pCurrentSize;
    currentSpeed = pCurrentSpeed;
    size = pCurrentSize;
    isConnected = true;
  }

  void show() {
    stroke(0, 0, 0);
    strokeWeight(2);
    fill(0, 0, 50);
    circle(position.x, position.y, size);
  }

  void grow(int pCurrentSize) {
    if (size < pCurrentSize) {
      if (isConnected == true) {
        size = size + 0.1;
      }
      else {
        size -= 0.4;
      }
    } else {
      size -= 0.4;
    }
    //println(pCurrentSize);
  }

  //void move(float pCurrentSpeed, int pCurrentRange) {

  //  if (moveCycleCount % (60 / pCurrentSpeed) == 0) {
  //  nextPosition = new PVector(random(position.x - pCurrentRange, position.x + pCurrentRange), random(position.y - pCurrentRange, position.y + pCurrentRange));
  //  }

  //  float moveIncrementX = (nextPosition.x - position.x) / (60 / pCurrentSpeed);
  //  float moveIncrementY = (nextPosition.y - position.y) / (60 / pCurrentSpeed);
  //  position.x += moveIncrementX;
  //  position.y += moveIncrementY;

  //  moveCycleCount++;
  //}

  void move(PVector target, float pCurrentSpeed, int pCurrentRange) {

    PVector force = PVector.sub(target, position);
    float distance = force.mag();
    distance = constrain(distance, 1, pCurrentRange * 4);
    //float G = 7500 / pCurrentRange;
    float G = 500;
    float strength = G / sq(distance);
    force.setMag(strength);

    if (distance < pCurrentRange) {
      force.mult(-1.2);
    }
    if (position.x - size / 2 <= 0 || position.x + size / 2 >= 1280) {
      velocity.x = velocity.x * -1;
    }
    if (position.y - size / 2 <= 0 || position.y + size / 2 >= 720) {
      velocity.y = velocity.y * -1;
    }

    acceleration.add(force);
    velocity.add(acceleration);
    velocity.limit(5);
    position.add(velocity);
    acceleration.mult(0);
  }

  void disconnected() {
    isConnected = false;
  }

  void connected() {
    isConnected = true;
  }
}
