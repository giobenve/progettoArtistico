
import fisica.*;
import geomerative.*;

FWorld world;
//String filename = "pink.svg";
  int orgid = 0;
  PImage b;
  Stone stone;
  
void setup(){
  size(500, 500);
  smooth();
  b = loadImage("sabbia.jpg");
  
  
  frameRate(15);

  Fisica.init(this);
  Fisica.setScale(10);
  
  RG.init(this);
  
  RG.setPolygonizer(RG.ADAPTATIVE);

  world = new FWorld();
  world.setEdges(this, color(0));
  world.setGravity(0, 0);
  
  
  world.add(new Organism(orgid, width/2, height/2));  
  
}

void draw(){
  //image(b, 0, 0, width/2, height/2);
  background(b);
  world.draw(this);
  
  if (stone != null) {
    stone.draw(this);
  }
  
  world.step();
}

void mousePressed(){
  if (world.getBody(mouseX, mouseY) == null) {
    if (orgid >= 0) {
      world.add(new Organism(orgid, mouseX, mouseY));
    }
    else {
      stone = new Stone();
      stone.vertex(mouseX, mouseY);
    }

  
  }
}

void mouseDragged() {
  if (stone!=null) {
    stone.vertex(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (stone!=null) {
    world.add(stone);
    stone = null;
  }
}


void keyPressed() {
  
  if (key == CODED) {
    println(keyCode);
  }
  else {
    int intk = -1;
    try {
      intk = Integer.parseInt(key + "");
      orgid = intk;
    }
    catch (NumberFormatException e) {
    }
    if (intk == -1) {
      switch (key) {
      case 'p':
      world.add(new Food(mouseX, mouseY));
      break;
      case 's':
      orgid = -1;
      break;
      }
    }
  }
}

void contactStarted(FContact c) {
  FBody b1 = c.getBody1();
  FBody b2 = c.getBody2();
  
  if (b1 instanceof Food && b2 instanceof Food) {
  
  } else if (b1 instanceof Food && !(b2 instanceof Food) && !b2.isStatic()) {
    world.remove(b1);
  } else if (!(b1 instanceof Food) && b2 instanceof Food && !b1.isStatic()) {
    world.remove(b2);
  } 
  
}
