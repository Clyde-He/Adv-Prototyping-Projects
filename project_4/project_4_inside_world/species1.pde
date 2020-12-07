class species1 {
  PVector position = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);
  float size;
  
  PVector nextPosition = new PVector(0, 0);
  int moveCycleCount = 0;
  
  int currentSize;
  float currentSpeed;
  
  boolean isConnected;

  species1(float pSpawnPosX, float pSpawnPosY, int pCurrentSize, float pCurrentSpeed, boolean pIsConnected) {
    position.x = pSpawnPosX;
    position.y = pSpawnPosY;
    currentSize = pCurrentSize;
    currentSpeed = pCurrentSpeed;
    size = 0;
    isConnected = false;
  }

  void show() {
    stroke(0,0,0);
    strokeWeight(1);
    fill(0,0,100);
    circle(position.x, position.y, size);
  }
  
  void grow(int pCurrentSize) {
    if (size < pCurrentSize && isConnected == true) {
      size = size + 0.1;
    }
    else {
      size -= 0.1;
    }
    //println(pCurrentSize);
  }

  void move(float pCurrentSpeed, int pCurrentRange) {
    if (moveCycleCount % (60 / pCurrentSpeed) == 0) {
    nextPosition = new PVector(random(position.x - pCurrentRange, position.x + pCurrentRange), random(position.y - pCurrentRange, position.y + pCurrentRange));
    }
    
    float moveIncrementX = (nextPosition.x - position.x) / (60 / pCurrentSpeed);
    float moveIncrementY = (nextPosition.y - position.y) / (60 / pCurrentSpeed);
    position.x += moveIncrementX;
    position.y += moveIncrementY;
    
    moveCycleCount++;
  }
  
  void disconnected() {
    isConnected = false;
    println("got it!!!!" + isConnected);
  }
  
}
