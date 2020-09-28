ArrayList<Bubble> allBubbles = new ArrayList<Bubble>();
ArrayList<Leaf> allLeaves = new ArrayList<Leaf>();
int leafShowFrequency = 0;
int leafShowFrequencyCounter = 0;
float envEffector;


void setup() {
  frameRate(60);
  size(1024, 1024);
  background(255, 255, 255);
  envEffector = random(0, 2);
}

void draw() {
  background(255, 255, 255);

  if (leafShowFrequency == 0) {
    //leafShowFrequency = 240;
    leafShowFrequency = int(random(45, 105) * envEffector);
  } else {
    leafShowFrequencyCounter += 1;
  }

  if (leafShowFrequencyCounter == leafShowFrequency) {
    allLeaves.add(new Leaf(envEffector));
    leafShowFrequency = 0;
    leafShowFrequencyCounter = 0;
  }

  for (Leaf currentLeaf : allLeaves) {
    currentLeaf.show();
    currentLeaf.move();
  }

  for (int index = allLeaves.size() - 1; index >= 0; index--) {
    Leaf tempLeaf = allLeaves.get(index);
    //print(tempLeaf.gone());
    //print("----------");
    if (tempLeaf.gone()) {
      allLeaves.remove(index);
      printArray(allLeaves);
    }
  }

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
  allBubbles.add(new Bubble(mouseX, mouseY, envEffector));
}
