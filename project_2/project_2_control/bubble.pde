class Bubble {
  PVector position = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);
  int size;
  color bubbleColor;
  int breakCycle;
  int breakCycleCounter = 0;
  int colorH;

  Bubble(float tempPosX, float tempPosY, int windLevel) {
    position.x = tempPosX;
    position.y = tempPosY;
    size = int(random(25, 50));
    velocity = new PVector(random(-5, 5), random(-5, 5));
    colorH = int(random(0, 360));
    //s = int(random(50, 100));
    //bubbleColor = color(random(0, 360), random(50, 100), random(75, 100));
    breakCycle = int(random(240, 1200) / windLevel * 2);
  }

  void applyWind(PVector wind) {
    PVector force = new PVector(wind.x / size, wind.y);
    acceleration.add(force);
  }

  void show() {
    stroke(0,0,100);
    strokeWeight(0.1);
    //fill(bubbleColor);
    for (int tempSize = size; tempSize>0; --tempSize) {
      fill(colorH, map(tempSize, 0, size, 0, 40), 100, map(tempSize, 0, size, 25, 10));
      circle(position.x, position.y, tempSize);
      //s -= 1;
      //println(tempSize);
    }
  }

  void move() {

    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);

    if (position.x >= width - size / 2 || position.x <= size / 2) {
      velocity.x = velocity.x * -1;
    }

    if (position.y >= height - size / 2 || position.y <= size / 2) {
      velocity.y = velocity.y * -1;
    }
  }

  boolean boop() {
    breakCycleCounter += 1;
    return breakCycleCounter == breakCycle;
  }
}
