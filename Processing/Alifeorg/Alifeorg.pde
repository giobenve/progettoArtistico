
import fisica.*;
import geomerative.*;

FWorld world;
//String filename = "pink.svg";
int orgid = 0;
PImage b;
Stone stone;

void setup() {
  size(1200, 500);
  //smooth();
  b = loadImage("sabbia.jpg");
  b.resize(width, height);

  frameRate(30);

  Fisica.init(this);
  Fisica.setScale(10);

  RG.init(this);

  RG.setPolygonizer(RG.ADAPTATIVE);

  world = new FWorld();
  world.setEdges(this, color(0));
  world.setGravity(0, 0);


  world.add(new Pink(width/2, height/2,color(random(255), random(255), random(255))));
}

void draw() {

  background(b);
  world.draw(this);

  if (stone != null) {
    stone.draw(this);
  }

  world.step();
}

void mousePressed() {
  FBody hovered = world.getBody(mouseX, mouseY);
  if (hovered == null) {
     switch (orgid) {
      case 0:
        world.add(new Pink(mouseX, mouseY, color(random(255), random(255), random(255))));
        break;
      case 1:
        world.add(new Orange(mouseX, mouseY, color(random(255), random(255), random(255))));
        break;
      case 2:
        world.add(new Green(mouseX, mouseY, color(random(255), random(255), random(255))));
        break;
      case -1:
        stone = new Stone();
        stone.vertex(mouseX, mouseY);
        break;
      }
  } else if (orgid == -2) {//Cancello corpo
    world.remove(hovered);
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
      orgid = constrain(intk, 0, 2);
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
      case 'c':
        orgid = -2;
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
  } else if (b1 instanceof Food && !(b2 instanceof Food) && !b2.isStatic()) {
    Food f = (Food) b1;
    Organism o = (Organism) b2;
    if (o.good(f)) {
    world.remove(f);
    o.mangia(f); }
  } else if (!(b1 instanceof Food) && b2 instanceof Food && !b1.isStatic()) {
    Food f = (Food) b2;
    Organism o = (Organism) b1;
    if (o.good(f)) {
    world.remove(f);
    o.mangia(f); }
  }
}


