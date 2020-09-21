Car myCar;

void setup(){    
  myCar = new Car(color(255,20,30), 50, 50, 2, 40);
  size(1024,1024);
  background(255);
}

void draw() {
  background(255); 
  myCar.drive();
  myCar.display();
}

class Car {
  color c;
  float xPos;
  float yPos;
  float speed;
  float size;

  Car(color tempC, float tempXPos, float tempYPos, float tempSpeed, float tempSize) { 
    c = tempC;
    xPos = tempXPos;
    yPos = tempYPos;
    speed = tempSpeed;
    size = tempSize;
  }

  void display() {
    stroke(0);
    fill(c);
    rect(xPos,yPos,size * 2,size);
  }

  void drive() {
    xPos = xPos + speed;
    if (xPos > width) {
      xPos = -size;
    }
  }
}
