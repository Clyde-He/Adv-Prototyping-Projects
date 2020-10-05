class Bubble {
  PVector position = new PVector(0,0);
  PVector acceleration = new PVector(0,0);
  PVector velocity = new PVector(0,0);
  float size;
  color bubbleColor;
  int breakCycle;
  int breakCycleCounter = 0;

  Bubble(float tempPosX, float tempPosY, int windLevel) {
    position.x = tempPosX;
    position.y = tempPosY;
    size = random(50, 100);
    velocity = new PVector(random(-5, 5), random(-5, 5));
    bubbleColor = color(random(0, 255), random(0, 255), random(0, 255), 100);
    breakCycle = int(random(240, 1200) / windLevel * 2);
  }
  
  void applyWind(PVector wind) {
    PVector force = new PVector(wind.x / size, wind.y);
    acceleration.add(force);
  }

  void show() {
    noStroke();
    fill(bubbleColor);
    circle(position.x, position.y, size);
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
