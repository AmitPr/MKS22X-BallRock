interface Displayable {
  void display();
}

interface Moveable {
  void move();
}

abstract class Thing implements Displayable {
  float x, y;//Position of the Thing

  Thing(float x, float y) {
    this.x = x;
    this.y = y;
  }
  abstract void display();
}

class Rock extends Thing {
  Rock(float x, float y) {
    super(x, y);
  }

  void display() {
    fill(75, 100, 75);
    ellipse(x,y,20,20);
  }
}

public class LivingRock extends Rock implements Moveable {
  
  float circleRadius = random(50, 200);
  float timeMultiplier = random(0.001, 0.003);
  
  LivingRock(float x, float y) {
    super(x, y);
  }
  void move() {
    //x += random(-3, 3);
    //y += random(-3, 3);
        
    x = width / 2 + (circleRadius * cos(timeMultiplier * millis()));
    y = height / 2 + (circleRadius * sin(timeMultiplier * millis()));
  }
}

class Ball extends Thing implements Moveable {
  Ball(float x, float y) {

    super(x, y);
  }

  void display() {
    fill(255,0,0);
    ellipse(x,y,50,50);
  }

  void move() {
    x+=0.5-random(1);
    y+=0.5-random(1);
  }
}

/*DO NOT EDIT THE REST OF THIS */

ArrayList<Displayable> thingsToDisplay;
ArrayList<Moveable> thingsToMove;

void setup() {
  size(1000, 800);

  thingsToDisplay = new ArrayList<Displayable>();
  thingsToMove = new ArrayList<Moveable>();
  for (int i = 0; i < 10; i++) {
    Ball b = new Ball(50+random(width-100), 50+random(height-100));
    thingsToDisplay.add(b);
    thingsToMove.add(b);
    Rock r = new Rock(50+random(width-100), 50+random(height-100));
    thingsToDisplay.add(r);
  }
  for (int i = 0; i < 3; i++) {
    LivingRock m = new LivingRock(50+random(width-100), 50+random(height-100));
    thingsToDisplay.add(m);
    thingsToMove.add(m);
  }
}
void draw() {
  background(255);

  for (Displayable thing : thingsToDisplay) {
    thing.display();
  }
  for (Moveable thing : thingsToMove) {
    thing.move();
  }
}
