ArrayList<Bubble> allBubbles = new ArrayList<Bubble>();

void setup() {
  size(1024, 1024);
  background(255, 255, 255);
}

void draw() {
  background(255, 255, 255);
  for (Bubble currentBubble : allBubbles) {
    currentBubble.show();
    currentBubble.move();
  }

  for (int index = allBubbles.size() - 1; index >= 0; index--) {
    Bubble currentBubble = allBubbles.get(index);
    if (currentBubble.boop()) {
      allBubbles.remove(index);
    }
  }

  //print(allBubbles.size);
}

void mouseClicked() {
  allBubbles.add(new Bubble(mouseX, mouseY, random(0.1, 2)));
}
