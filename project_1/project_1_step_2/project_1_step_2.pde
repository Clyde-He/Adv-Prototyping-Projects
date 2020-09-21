float posX = 100;
float posY = 100;
float velX = 5;
float velY = 5;

//runs before the main loop
//in preperation
void setup() {
  size(1280, 720);
}

//this is the main loop
void draw(){
  //background(255, 255, 255);
  
  if (posX >= width - posX / 20 || posX <= posX / 20) {
    velX = velX * -1;
  }
  
  if (posY >= height - posX / 20 || posY <= posX / 20) {
    velY = velY * -1;
  }
  
  posX += velX;
  posY += velY;
  circle(posX, posY, posX / 10);

}
