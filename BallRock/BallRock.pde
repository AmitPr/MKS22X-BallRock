interface Displayable {
  void display();
}

interface Collideable{
  boolean isTouching(Thing other);
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

class Rock extends Thing implements Collideable {
  float rMod,gMod,bMod,xMod,yMod,wid,hig;
  int type;
  Rock(float x, float y) {
    super(x, y);
    type = (int)random(2);
    rMod=random(-16,16);gMod=random(-16,16);bMod=random(-16,16);
    xMod=random(-20,20);yMod=random(-10,10);
    wid=random(-10,10);hig=random(-10,10);
  }
  void display_old() {
    fill(75+rMod, 100+gMod, 75+bMod);
    ellipse(x,y,40,20);
    for(int i=0;i<1;i++){
      ellipse(x+xMod,y+yMod,wid,hig);
    }
  }
  boolean isTouching(Thing other){
    if(dist(other.x,other.y,x,y)<=50){
     return true; 
    }
    return false;
  }
  void display(){
    if(type==0)
      image(dwayne,x,y,30,40);
    else
      image(stone,x,y,40,40);
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

class Ball extends Thing implements Moveable  {
  int mode;
  float xv,yv,r,g,b;
  Ball(float x, float y) {
    super(x, y);
    mode=int(random(4));
    xv = 1-random(2);
    yv = 1-random(2);
    r = random(255);
    g = random(255);
    b = random(255);
  }

  void display() {
    ellipseMode(RADIUS);
        fill(r,g,b);
    for(Collideable c : thingsToCollide){
      if(c.isTouching(this)){
        fill(255,0,0);
      }
    }
    ellipse(x,y,50,50);
  }

  void move() {
  }
}
class GravityBall extends Ball {
  GravityBall(float x, float y){
    super(x,y);
  }
  void move(){
      x+=xv;
      if(x+50>width || x-50<0){
        xv*=-1;
      }
      y-=yv;
      yv-=0.2;
      
      if(y+50>height){
        yv*=-0.8 - random(0.3);
        y=height-50;
      }
  }
}
class PongBall extends Ball {
  PongBall(float x, float y){
    super(x,y);
  }
  void move(){
      x+=xv;
      if(x+50>width || x-50<0){
        xv*=-1;
      }
      y+=yv;
      if(y+50>height || y-50<0){
        yv*=-1;
      }
  }
}

/*DO NOT EDIT THE REST OF THIS */

ArrayList<Displayable> thingsToDisplay;
ArrayList<Moveable> thingsToMove;
ArrayList<Collideable> thingsToCollide;
PImage dwayne,stone;

void setup() {
  size(1000, 800);
  stone = loadImage("stone.png");
  dwayne = loadImage("Dwayne-Johnson-Variety--e1505509144619.png");
  thingsToDisplay = new ArrayList<Displayable>();
  thingsToMove = new ArrayList<Moveable>();
  thingsToCollide = new ArrayList<Collideable>();
  for (int i = 0; i < 10; i++) {
    Ball b;
    if(i < 5){
      b=new PongBall(50+random(width-100), 50+random(height-100));
    }else{
      b=new GravityBall(50+random(width-100), 50+random(height-100));
    }
    thingsToDisplay.add(b);
    thingsToMove.add(b);
    Rock r = new Rock(50+random(width-100), 50+random(height-100));
    thingsToDisplay.add(r);
    thingsToCollide.add(r);
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
