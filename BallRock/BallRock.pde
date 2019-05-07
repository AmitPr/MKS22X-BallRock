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
  float rMod,gMod,bMod,xMod,yMod,wid,hig;
  Rock(float x, float y) {
    super(x, y);
    rMod=random(-16,16);gMod=random(-16,16);bMod=random(-16,16);
    xMod=random(-20,20);yMod=random(-10,10);
    wid=random(-10,10);hig=random(-10,10);
  }
  void display() {
    fill(75+rMod, 100+gMod, 75+bMod);
    ellipse(x,y,40,20);
    for(int i=0;i<1;i++){
      ellipse(x+xMod,y+yMod,wid,hig);
    }
  }
}

public class LivingRock extends Rock implements Moveable {
  
  float circleRadius = random(50, 200);
  float timeMultiplier = random(0.001, 0.003);
  
  int randomStart = int(random(4));
  
  PVector[] path = new PVector[] {new PVector(0, 0), new PVector(width/2, height/2), new PVector(width/3, 2 * height/3), new PVector(width/5, 7*height/8), new PVector(4*width/5, 1*height/8), new PVector(width, height)};
  
  LivingRock(float x, float y) {
    super(x, y);
  }
  void move() {
    //x += random(-3, 3);
    //y += random(-3, 3);
        
    //x = width / 2 + (circleRadius * cos(timeMultiplier * millis()));
    //y = height / 2 + (circleRadius * sin(timeMultiplier * millis()));
    
    float millisPerPath = 2000;
    
    float seconds = millis() / millisPerPath;
    float t = seconds % 1;
    int idx = (int) ((seconds + randomStart) % path.length);
    PVector p1 = path[idx];
    PVector p2 = path[(idx + 1) % path.length];
    
    PVector newPos = lerpVec(p1, p2, t);
    x = newPos.x;
    y = newPos.y;
  }
  
  private PVector lerpVec(PVector a, PVector b, float t) {
    return new PVector(lerp(a.x, b.x, t), lerp(a.y, b.y, t));
  }
}

class Ball extends Thing implements Moveable {
  int mode;
  float xv,yv;
  Ball(float x, float y) {

    super(x, y);
    mode=int(random(4));
    xv = 1-random(2);
    yv = 1-random(2);
  }

  void display() {
    ellipseMode(RADIUS);
    switch(mode){
      case 0:
        fill(255,0,0);
        break;
      case 1:
        fill(0,255,0);
        break;
      case 2:
        fill(0,0,255);
        break;
      case 3:
        fill(0,255,255);
        break;
      default:
        fill(0);
        break;
    }
    ellipse(x,y,50,50);
  }

  void move() {
    if(mode == 0){
      x+=1-random(2);
      y+=1-random(2);
    }
    if(mode == 1){
      x+=xv;
      if(x>width || x<0){
        xv*=-1;
      }
      y+=yv;
      if(y>height || y<0){
        yv*=-1;
      }
    }
    if(mode == 2){
      x+=xv;
      if(x>width || x<0){
        xv*=-1;
      }
      y-=yv;
      if(yv>-16){
        yv-=0.2;
      }
      
      if(y>height){
        yv*=-0.9;
      }
    }
    if(mode == 3){
      xv-=0.5-random(1);
      yv-=0.5-random(1);
      x+=xv;
      if(x>width || x<0){
        xv*=-1;
      }
      y+=yv;
      if(y>height || y<0){
        yv*=-1;
      }
    }
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
