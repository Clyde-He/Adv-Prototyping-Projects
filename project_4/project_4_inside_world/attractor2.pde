class attractor2 {
  PVector position = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);
  
  PVector nextPosition = new PVector(0, 0);
  int moveCycleCount = 0;
  
  float currentSpeed;
  
  attractor2(float pSpawnPosX, float pSpawnPosY, float pCurrentSpeed) {
    position.x = pSpawnPosX;
    position.y = pSpawnPosY;
    currentSpeed = pCurrentSpeed;
  }
  
  void show() {
    stroke(0,100,100);
    strokeWeight(2);
    fill(0,0,100);
    circle(position.x, position.y, 20);
  }
  
  void move(float pCurrentSpeed, int pCurrentRange) {
    if (moveCycleCount % (60 / pCurrentSpeed) == 0) {
    nextPosition = new PVector(random(position.x - pCurrentRange * 2, position.x + pCurrentRange * 2), random(position.y - pCurrentRange * 2, position.y + pCurrentRange * 2));
    }
    
    float moveIncrementX = (nextPosition.x - position.x) / (60 / pCurrentSpeed);
    float moveIncrementY = (nextPosition.y - position.y) / (60 / pCurrentSpeed);
    position.x += moveIncrementX;
    position.y += moveIncrementY;
    
    moveCycleCount++;
  }
  
}
