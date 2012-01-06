
abstract class Organism extends FPoly {
  RShape[] corpo = new RShape[4];
  RShape[] occhi = new RShape[9];
  RShape outline;
  //String[] files = new String[] {"pink.svg", "orange.svg", "green.svg", "rocciaori.svg", "rocciaver.svg" };

  color gene0;//Colore
  int gene1;//Onnivoro
  int gene2;//Raggio vista

  Organism(int x, int y, String file) {
    super();

    float angle = random(TWO_PI);
    float magnitude = 50;

    this.setPosition(x, y);
    this.setRotation(angle+PI/2);
    this.setVelocity(magnitude*cos(angle), magnitude*sin(angle));
    /*this.setDamping(0);
    this.setAngularDamping(0.5);*/
    this.setRestitution(0.5);
    this.setDensity(0.7);
    /*this.setGrabbable(false);*/

    RShape fullSvg = RG.loadShape(file);
    for (int i=0; i<corpo.length; i++) {//Carico forma corpo
      corpo[i] = fullSvg.getChild("object"+(i+1));
    }
    for (int i=0; i<occhi.length; i++) {//Carcio forma occhi
      occhi[i] = fullSvg.getChild("occhi"+(i+1));
    }
    outline = fullSvg.getChild("outline");


    if (outline == null) {
      println("ERROR: Couldn't find the shapes called 'outline' in the SVG file.");
      return;
    }

    RPoint[] points = outline.getPoints();

    for (int i=0; i<points.length; i++) {
      this.vertex(points[i].x, points[i].y);
    }

    this.setNoFill();
    this.setNoStroke();
  }

  int j = 0;//per disegnare corpo
  int o = 0;//per disegnare occhi

  int rotationTimer = 0;
  int predationTimer = 0;
  int dimagrimentoTimer = 0;

  void draw(PGraphics applet) {
    preDraw(applet);
    //Movimento corpo
    corpo[j].draw(applet);
    j = (j + 1 ) % 4;

    //Movimento occhi
    if (random(0, 25) > 24) o = 8;
    if (o != 0) {
      occhi[o].draw(applet);
      o--;
    }

    postDraw(applet);
    
    if (abs(mouseX-getX()) < 20 && abs(mouseY-getY()) < 20) {
      fill(gene0, 50);  
      ellipse(getX(), getY(), gene2, gene2);
      fill(gene0, 70);
      ellipse(getX(), getY(), gene1, gene1);
      noFill();
    }

    pushMatrix();
    translate(getX(), getY());
    rotate(getRotation());
    /*DEBUG
    stroke(0);
    line(0, 0, getVelocityX(), getVelocityY()); 
    noStroke();

    fill(255, 0, 0);  
    //ellipse(0, 0, 2, 2);
    
    noFill();
    //DEBUG
    */

    /*if ((millis() - rotationTimer) > 1000) {//Per farlo nuotare dritto
     if (getContacts().size() == 0) {
     setRotation( - (atan2(getVelocityX(), getVelocityY()) - PI));
     } 
     else {
     rotationTimer = millis();
     }
     }*/
    popMatrix();


    //if ((millis() - predationTimer) > 1000) {//Per fargli inseguire il cibo

    predation();

    //predationTimer = millis();

    //}

    if ((millis() - dimagrimentoTimer) > 20000) {
      dimagrisci();
    }
  }

  FBody target;

  void predation() {
    if (target == null) {
      ArrayList allb = m_world.getBodies();
      for (int i=0; i<allb.size(); i++) {//Cerco Food
        FBody b = (FBody) allb.get((int)random(0, allb.size()));
        if (
          b instanceof Food &&
          dist(getX(), getY(), b.getX(), b.getY()) < 200 &&
          good(b) {//Distanza dal cibo
          target = b;
          setVelocity(target.getX()-getX(), target.getY()-getY());
          break;
        }
      }
    }
    if (target != null) {
      //TODO non funziona if (!target.isDrawable()) {target = null; return;}
      addForce(target.getX()-getX(), target.getY()-getY());
      
      /* DEBUG
      stroke(0);
      line(getForceX()-getX(), getForceY()-getY(), getX(), getY());
      line(target.getX(), target.getY(), getX(), getY());
      noStroke();
      */
    }
  }
  
  abstract void mangia(FBody f);
  
  public boolean good(FBody f) {
    if (f instanceof Food) {
      Food fo = (Food) f;
      return dist(red(fo.gene0), green(fo.gene0), blue(fo.gene0), red(gene0), green(gene0), blue(gene0)) < gene1;
    }
    return false;  
  }

  void dimagrisci() {
    //Muore
    if (outline.getHeight() < 15) {
      m_world.remove(this);
      return;
    }

    recreate(0.9);
    dimagrimentoTimer = millis();
  }

  void recreate(float f) {

    for (int i=0; i<corpo.length; i++) {//Scalo corpo
      corpo[i].scale(f);
    }
    for (int i=0; i<occhi.length; i++) {//Scalo occhi
      occhi[i].scale(f);
    }
    outline.scale(f);
    //Ricreo poligono
    RPoint[] points = outline.getPoints();

    this.m_vertices = new ArrayList();
    for (int i=0; i<points.length; i++) {
      this.vertex(points[i].x, points[i].y);
    }


    recreateInWorld();
  }
  
}


