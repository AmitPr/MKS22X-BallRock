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
  //float rMod,gMod,bMod,xMod,yMod,wid,hig;
  boolean isStone;
  Rock(float x, float y) {
    super(x, y);
    isStone = 1>random(2);
    //rMod=random(-16,16);gMod=random(-16,16);bMod=random(-16,16);xMod=random(-20,20);yMod=random(-10,10);wid=random(-10,10);hig=random(-10,10);
  }
  /*void display_old() {
    fill(75+rMod, 100+gMod, 75+bMod);
    ellipse(x,y,40,20);
    for(int i=0;i<1;i++){
      ellipse(x+xMod,y+yMod,wid,hig);
    }
  }*/
  boolean isTouching(Thing other){
    if(dist(other.x,other.y,x+25,y+30)<=60){
     return true; 
    }
    return false;
  }
  void display(){
    if(!isStone)
      image(dwayne,x,y,50,70);
    else
      image(stone,x,y,50,50);
  }
}

public class LivingRock extends Rock implements Moveable {
  
  float circleRadius = random(50, 200);
  float timeMultiplier = random(0.001, 0.003);
  
  int randomStart = int(random(4));
  
  int mode;
  
  PVector[] path;
  
  
  LivingRock(float x, float y) {
    super(x, y);
    
    path = new PVector[12];
    for (int i = 0; i < path.length; i++) {
      path[i] = new PVector(random(0, width), random(0, height));
    }
    
    mode = (int) random(0, 3);
  }

void display(){
    int eyeH=4;int eyeW=6; int eyeY=28; int leftEyeX=10; int rightEyeX=28;
    if(isStone){
      leftEyeX=15;rightEyeX=35; eyeY=15;
    }
    ellipseMode(RADIUS);
    super.display();
    fill(255);
    ellipse(x+leftEyeX,y+eyeY,eyeW,eyeH);ellipse(x+rightEyeX,y+eyeY,eyeW,eyeH);
    fill(0);
    ellipse(x+leftEyeX,y+eyeY, 2,2);ellipse(x+rightEyeX,y+eyeY, 2,2);
  }
  
  int prevIndex = -1;
  int incrementer = 0;

  void move() {
    
    if (mode == 0) {
      x += random(-3, 3);
      y += random(-3, 3);
    }
    
    else if (mode == 1) {
      x = width / 2 + (circleRadius * 1.5 * cos(timeMultiplier * millis()));
      y = height / 2 + (circleRadius * sin(timeMultiplier * millis()));
    }
    
    else {
    
      float millisPerPath = 2000;
      
      float seconds = millis() / millisPerPath;
      float t = seconds % 1;
      int origIdx = (int) ((seconds + randomStart) % path.length);
      if (origIdx != prevIndex) incrementer++;
      int idx = origIdx + incrementer;
      idx = idx % path.length;
      PVector p1 = path[idx];
      PVector p2 = path[(idx + 1) % path.length];
      PVector p3 = path[(idx + 2) % path.length];
      
      PVector lerped1 = lerpVec(p1, p2, t);
      PVector lerped2 = lerpVec(p2, p3, t);
      PVector newPos = lerpVec(lerped1, lerped2, t);
      x = newPos.x;
      y = newPos.y;
      
      prevIndex = origIdx;
    }
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
  void changeFill(){
    for(Collideable c : thingsToCollide){
      if(c.isTouching(this)){
        fill(255,0,0);
      }
    }
  }

  void display() {
    ellipseMode(RADIUS);
    changeFill();
    ellipse(x,y,50,50);
  }
  void move() {}
  
}
class GravityBall extends Ball {
  GravityBall(float x, float y){
    super(x,y);
  }
  void changeFill(){
    fill(lerp(0,255,x/width),lerp(0,255,y/height),lerp(0,255,((x/width)+(y/height))/2));
    //fill(r,g,b);
    super.changeFill();
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
    xv*=random(20);
    yv*=random(20);
  }
  void changeFill(){
    fill(r,g,b);
    super.changeFill();
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
