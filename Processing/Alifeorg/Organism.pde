
class Organism extends FPoly {
  RShape[] corpo = new RShape[4];
  RShape[] occhi = new RShape[9];
  RShape outline;
  String[] files = new String[] {
    "pink.svg", "orange.svg", "green.svg", "rocciaori.svg", "rocciaver.svg"
  };
  int orgid;

  Organism(int orgid, int x, int y) {
    super();

    float angle = random(TWO_PI);
    float magnitude = 50;

    this.orgid = orgid;
    this.setPosition(x, y);
    this.setRotation(angle+PI/2);
    this.setVelocity(magnitude*cos(angle), magnitude*sin(angle));
    this.setDamping(0);
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

  void draw(PGraphics applet) {
    preDraw(applet);

    if (random(0, 25) > 24) {
      o = 8;
    }   

    corpo[j].draw(applet);
    j = (j + 1 ) % 4;

    if (o != 0) {
      occhi[o].draw(applet);
      o--;
    } 

    //setRotation(atan2(getVelocityX(), getVelocityY()) - HALF_PI);

    postDraw(applet);
    //DEBUG
    pushMatrix();
    translate(getX(), getY());
    /*DEBUG
    stroke(0);
    line(0, 0, getVelocityX(), getVelocityY()); 
    noStroke();

    fill(255, 0, 0);  
    ellipse(0, 0, 5, 5);
    noFill();
    */
    
    /*if ((millis() - rotationTimer) > 1000) {//Per farlo nuotare dritto
      if (getContacts().size() == 0) {
        setRotation( - (atan2(getVelocityX(), getVelocityY()) - PI));
      } 
      else {
        rotationTimer = millis();
      }
    }*/

    if ((millis() - predationTimer) > 1000) {//Per fargli inseguire il cibo
      ArrayList js = getJoints();

      if (js.size() == 0) {
        ArrayList allb = m_world.getBodies();
        for (int i=0; i<allb.size(); i++) {
          FBody b = (FBody) allb.get(i);
          if (b instanceof Food) {
            if (dist(getX(), getY(), b.getX(), b.getY()) < 200) {//Distanza dal cibo

              FDistanceJoint dj = new FDistanceJoint(this, b);
              dj.setAnchor1(outline.getWidth()/2,outline.getHeight()/2);
              //FPrismaticJoint dj = new FPrismaticJoint(b, this);
              //FMouseJoint dj = new FMouseJoint(this, width/2, height/2);
              dj.setLength(0);
              dj.setDrawable(false);
              dj.setFrequency(0.1);
              m_world.add(dj);


              break;
            }
          }
        }
      } 
      
      predationTimer = millis();
      
    }

    //println(atan2(getVelocityX(), getVelocityY()) - HALF_PI);
    popMatrix();
    //DEBUG

    if ((int)(frameCount % (frameRate*5)) < 1 && random(0, 10) > 8) {
    //if ((int)(frameCount % (frameRate*5)) <1) {
      dimagrisci();
    }
  }

  int s = 10;//grandezza default

  void mangia() {
    s = s + 1;

    //Figli
    if (s > 15) {
      s = 10;
      m_world.add(new Organism(orgid, (int)getX(), (int)getY()));
      recreate(0.25);
      return;
    }
    recreate(1.1);
  }

  void dimagrisci() {
    s = s - 1;

    if (s < 2) {
      m_world.remove(this);
      return;
    }

    recreate(0.9);
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

