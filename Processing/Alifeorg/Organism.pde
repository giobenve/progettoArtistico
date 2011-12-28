
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

    

    postDraw(applet);
    
    fill(255,0,0);  
    ellipse(getX(), getY(), 5, 5);
    noFill();
    
    //if ((int)(frameCount % (frameRate*5)) < 1 && random(0, 100) > 90) {
    if ((int)(frameCount % (frameRate*5)) <1) {
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
    
    if (s < 4) {
      m_world.remove(this);
      return;
    }

    recreate(0.9);
  }
  
  void recreate(float f) {
    
    for (int i=0; i<corpo.length; i++) {//Carico forma corpo
          //corpo[i].transform(-s/2, -s/2, s/2, s/2,true);
          corpo[i].scale(f);
    }
    for (int i=0; i<occhi.length; i++) {//Carcio forma occhi
          //occhi[i].transform(-s/2, -s/2, s/2, s/2,true);
          occhi[i].scale(f);
    }
    
    //outline.transform(-s/2, -s/2, s/2, s/2,true); 
    outline.scale(f);
    
    RPoint[] points = outline.getPoints();

    this.m_vertices = new ArrayList();
    for (int i=0; i<points.length; i++) {
      this.vertex(points[i].x, points[i].y);
    }
    recreateInWorld();
  }
}

