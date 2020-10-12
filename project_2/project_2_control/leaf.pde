class Leaf {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float size;
  float envEffector;
  float rotateAngle;
  float shapeControl1;
  float shapeControl2;
  color leafColor;

  Leaf() {
    position = new PVector(random(-512, 1536), -50);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    size = random(3, 6);
    rotateAngle = random(-PI, PI);
    shapeControl1 = random(18, 22);
    shapeControl2 = random(8, 12);
    
    leafColor = color(random(0, 40), random(122, 202), random(35, 115));
  }

  void show() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotateAngle);
    stroke(leafColor);
    fill(leafColor);
    curve(-shapeControl1 * size, 0, 0, 0, 0, shapeControl2 * size, -shapeControl1 * size, shapeControl2 * size);
    stroke(leafColor);
    curve(shapeControl1 * size, 0, 0, 0, 0, shapeControl2 * size, shapeControl1 * size, shapeControl2 * size);
    popMatrix();
  }

  void applyWind(PVector wind) {
    PVector force = new PVector(wind.x / size * 0.05, wind.y);
    acceleration.add(force);
  }
  
  void applyGravity(PVector gravity) {
    PVector force = new PVector(gravity.x, gravity.y * size * 0.05);
    acceleration.add(force);
  }

  boolean gone() {
    if (position.x >= 1536 || position.x <= -512 || position.y >= height) {
      return true;
    } else {
      return false;
    }
  }

  void move() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }
}
