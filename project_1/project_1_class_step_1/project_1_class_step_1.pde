float posX = 100;
float posY = 100;
float velXY = 5;

//runs before the main loop
//in preperation
void setup() {
  size(1280, 720);
}

//this is the main loop
void draw(){
  circle(posX, posY, posX / 10);
  posX += velXY;
  posY += velXY;
  println("posX:" + posX + "  " + "posY:" + posY);
}
