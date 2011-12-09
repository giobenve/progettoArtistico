
import fisica.*;
import geomerative.*;

FWorld world;
//String filename = "pink.svg";
  int orgid = 0;
  PImage b;

  
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
  world.step();
}

void mousePressed(){
  if (world.getBody(mouseX, mouseY) == null) {
    world.add(new Organism(orgid, mouseX, mouseY));
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
