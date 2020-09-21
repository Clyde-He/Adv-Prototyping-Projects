class Bubble {
  float posX;
  float posY;
  float size;
  float velX;
  float velY;
  color bubbleC;
  
  Bubble(float tempPosX, float tempPosY){
    posX = tempPosX;
    posY = tempPosY;
    size = random(50,100);
    velX = random(-5,5);
    velY = random(-5,5);
    bubbleC = color(random(200,255),random(200,255),random(200,255),40);
  }
  
  void show(){
    noStroke();
    fill(bubbleC);
    circle(posX,posY,size);
  }
  
  void move(){
    posX += velX;
    posY += velY;
    if (posX >= width - size / 2 || posX <= size / 2) {
      velX = velX * -1;
    }
    
    if (posY >= height - size / 2 || posY <= size / 2) {
      velY = velY * -1;
    }
  }
}
