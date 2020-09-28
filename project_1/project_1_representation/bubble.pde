class Bubble {
  float posX;
  float posY;
  float size;
  float velX;
  float velY;
  color bubbleColor;
  int breakCycle;
  int breakCycleCounter = 0;
  //float envEffector;

  Bubble(float tempPosX, float tempPosY, float tempEnvEffector) {
    posX = tempPosX;
    posY = tempPosY;
    size = random(50, 100);
    velX = random(-5, 5) * tempEnvEffector;
    velY = random(-5, 5) * tempEnvEffector;
    bubbleColor = color(random(200, 255), random(200, 255), random(200, 255), 90);
    breakCycle = int(random(150, 450) * tempEnvEffector);
  }

  void show() {
    noStroke();
    fill(bubbleColor);
    circle(posX, posY, size);
  }

  void move() {
    posX += velX;
    posY += velY;
    if (posX >= width - size / 2 || posX <= size / 2) {
      velX = velX * -1;
    }

    if (posY >= height - size / 2 || posY <= size / 2) {
      velY = velY * -1;
    }
  }

  boolean boop() {
    breakCycleCounter += 1;
    return breakCycleCounter == breakCycle;
  }

  float[] bubblePos() {
    float[] tempPos = {posX, posY};
    return tempPos;
  }
}
