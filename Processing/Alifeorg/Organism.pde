
class Organism extends FPoly {
  RShape[] corpo = new RShape[4];
  RShape[] occhi = new RShape[9];
  RShape outline;
  String[] files = new String[] {
    "pink.svg", "orange.svg", "green.svg", "rocciaori.svg", "rocciaver.svg"
  };
  int orgid;
  
  color gene;

  Organism(int orgid, int x, int y, color c) {
    super();

    gene = c;

    float angle = random(TWO_PI);
    float magnitude = 50;

    this.orgid = orgid;
    this.setPosition(x, y);
    this.setRotation(angle+PI/2);
    this.setVelocity(magnitude*cos(angle), magnitude*sin(angle));
    this.setDamping(0);
    this.setAngularDamping(0.5);
    this.setRestitution(0.5);
    this.setGrabbable(false);

    RShape fullSvg = RG.loadShape(files[orgid]);
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
    
    pushMatrix();
    translate(getX(), getY());
    rotate(getRotation());
    //DEBUG
    stroke(0);
    line(0, 0, getVelocityX(), getVelocityY()); 
    noStroke();

    fill(255, 0, 0);  
    ellipse(0, 0, 5, 5);
    fill(gene);  
    ellipse(outline.getWidth()/2,outline.getHeight()/3,5,5);
    noFill();
    //DEBUG
    
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

    if ((millis() - dimagrimentoTimer) > 10000) {
      dimagrisci();
    }
  }
  
  //Food target;
  
  void predation() {
    //if (target == null) {
       ArrayList allb = m_world.getBodies();
       for (int i=0; i<allb.size(); i++) {
          FBody b = (FBody) allb.get(i);
          if (b instanceof Food) {
            if (dist(getX(), getY(), b.getX(), b.getY()) < 200) {//Distanza dal cibo
              stroke(0);
              line(b.getX(), b.getY(),getX(), getY());
              noStroke();
              addForce(b.getX()-getX(), b.getY()-getY());
              return;
            
            }
          }
       }
    //}
  }

  void mangia() {
    //Figli
    if (outline.getHeight() > 80) {
      m_world.add(new Organism(orgid, (int)getX(), (int)getY(), gene));
      recreate(0.25);
      return;
    }
    recreate(1.1);
    dimagrimentoTimer = millis();
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

