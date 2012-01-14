import controlP5.*;
import fisica.*;
import geomerative.*;

ControlP5 controlP5;
GUI gui;
FWorld world;

PImage b;
Stone stone;

void setup() {
  size(1024, 768);

  smooth();
  b = loadImage("sand.jpg");
  b.resize(width, height);

  frameRate(24);
  
  controlP5 = new ControlP5(this);
  gui = new GUI(controlP5);

  Fisica.init(this);
  Fisica.setScale(10);

  RG.init(this);

  RG.setPolygonizer(RG.ADAPTATIVE);

  world = new FWorld();
  world.setEdges(this, color(0));
  world.setGravity(0, 0);


  world.add(new Pink((int)random(0, width), (int)random(0, height)));
  world.add(new Orange((int)random(0, width), (int)random(0, height)));
  world.add(new Green((int)random(0, width), (int)random(0, height)));
  
}

void draw() {

  background(b);
  world.draw(this);

  if (stone != null) {
    stone.draw(this);
  }

  world.step();
  fill(0);
  text(frameRate, width-50, height-20);
}

void mousePressed() {
  FBody hovered = world.getBody(mouseX, mouseY);
  if (hovered == null && !gui.panel.isVisible()) {
    switch (gui.orgid) {
    case 0:
      world.add(new Pink(mouseX, mouseY));
      break;
    case 1:
      world.add(new Orange(mouseX, mouseY));
      break;
    case 2:
      world.add(new Green(mouseX, mouseY));
      break;
    case -1://Disegno sasso
      stone = new Stone();
      stone.vertex(mouseX, mouseY);
      break;
    }
  } 
  else if (gui.orgid == -2) {//Cancello corpo
    world.remove(hovered);
  }
}

void mouseDragged() {
  if (stone!=null) {//Disegno sasso
    stone.vertex(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (stone!=null) {//Disegno sasso
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
      gui.orgid = constrain(intk, 0, 2);
    } 
    catch (NumberFormatException e) {
    }
    if (intk == -1) {
      switch (key) {
      case 'p':
        world.add(new Food(mouseX, mouseY, gui.cp.getColorValue()));
        break;
      case 's':
        gui.orgid = -1;
        break;
      case 'c':
        gui.orgid = -2;
        break;
      }
    }
  }
}

void contactStarted(FContact c) {
  FBody b1 = c.getBody1();
  FBody b2 = c.getBody2();

  if (b1 instanceof Food && b2 instanceof Food) {
    //Se due cibi si scontrano non fanno niente
  } 
  else if (!b1.isStatic() && !b2.isStatic()) {
    if (b1 instanceof Food && !(b2 instanceof Food)) {
      Organism o = (Organism) b2;
      o.mangia(b1);
    } 
    else if (!(b1 instanceof Food) && b2 instanceof Food) {
      Organism o = (Organism) b1;
      o.mangia(b2);
    }
    else if (b1 instanceof Green && !(b2 instanceof Food)) {
      Organism o = (Organism) b1;
      o.mangia(b2);
    } 
    else if (!(b1 instanceof Food) && b2 instanceof Green) {
      Organism o = (Organism) b2;
      o.mangia(b1);
    }
  }
}

