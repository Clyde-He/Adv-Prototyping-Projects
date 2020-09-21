ArrayList<Bubble> allBubbles = new ArrayList<Bubble>();

void setup() {
  size(1024, 1024);
  background(255, 255, 255);
}

void draw() {
  background(255, 255, 255);
  for (Bubble B : allBubbles) {
    B.show();
    B.move();
  }
  printArray(allBubbles);
}

void mouseClicked() {
  allBubbles.add(new Bubble(mouseX, mouseY));
}
