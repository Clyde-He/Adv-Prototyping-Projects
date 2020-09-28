class Leaf {
  float posX;
  float posY;
  float size;
  float velX;
  float velY;
  float envEffector;
  float angle;

  Leaf(float tempEnvEffector) {
    envEffector = tempEnvEffector;
    posX = random(0, 1024);
    posY = 0;
    size = random(25, 50);
    velX = random(-3, 3) * envEffector;
    velY = random(1, 3) * envEffector * 1.5;
    angle = random(-PI, PI);
  }

  void show() {
    pushMatrix();
    translate(posX, posY);
    rotate(angle);
    //noStroke();
    fill(color(0, 162, 75));
    //rotate(90);
    //square(posX, posY, size);
    stroke(color(255, 0, 0));
    curve(-150, 0, 0, 0, 0, 130, -150, 130);
    stroke(color(0, 255, 0));
    curve(150, 0, 0, 0, 0, 130, 150, 130);
    popMatrix();
  }

  float[] leafPos() {
    float[] tempPos = {posX, posY};
    return tempPos;
  }

  boolean gone() {
    if (posX >= width || posX <= 0 || posY >= height) {
      return true;
    } else {
      return false;
    }
  }

  void move() {
    posX += velX;
    posY += velY;
  }
}
