
class Organism extends FPoly {
  RShape[] m_shape = new RShape[13];
  RShape outline;
  String[] files = new String[] {
    "pink.svg", "orange.svg", "green.svg", "rocciaori.svg", "rocciaver.svg"
  };
  PImage images;

  float s = 70;
  
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

    //images = loadImage("PT_Shifty_0021.gif");
    //attachImage(images);

    RShape fullSvg = RG.loadShape(files[orgid]);
    m_shape[0] = fullSvg.getChild("object1");
    m_shape[1] = fullSvg.getChild("object2");
    m_shape[2] = fullSvg.getChild("object3");
    m_shape[3] = fullSvg.getChild("object4");
    m_shape[4] = fullSvg.getChild("occhi1");
    m_shape[5] = fullSvg.getChild("occhi2");
    m_shape[6] = fullSvg.getChild("occhi3");
    m_shape[7] = fullSvg.getChild("occhi4");
    m_shape[8] = fullSvg.getChild("occhi5");
    m_shape[9] = fullSvg.getChild("occhi6");
    m_shape[10] = fullSvg.getChild("occhi7");
    m_shape[11] = fullSvg.getChild("occhi8");
    m_shape[12] = fullSvg.getChild("occhi9");
    outline = fullSvg.getChild("outline");

    if (m_shape == null || outline == null) {
      println("ERROR: Couldn't find the shapes called 'object' and 'outline' in the SVG file.");
      return;
    }

    for (int i=0; i<m_shape.length; i++) {
      m_shape[i].transform(-s/2, -s/2, s/2, s/2);
    }
    outline.transform(-s/2, -s/2, s/2, s/2); 

    RPoint[] points = outline.getPoints();

    if (points==null) return;

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
      o = 9;
    }   
    
    m_shape[j].draw(applet);
    j = (j + 1 ) % 4;

    if (o != 0) {
      m_shape[o+3].draw(applet);
      o--;
    } 

    

    postDraw(applet);
    ellipse(getX(), getY(), 10, 10);
    
    if ((int)(frameCount % (frameRate*5)) < 1 && random(0, 100) > 90) {
      dimagrisci();
    }
  }
  
  void mangia() {
    s = s + 10;
    
    //Figli
    if (s > 150) {
      s = 100;
      m_world.add(new Organism(orgid, (int)getX(), (int)getY()));
    }
    recreate();
  }
  
  void dimagrisci() {
    s = s - 10;
    
    if (s < 40) {
      //this.removeFromWorld();
      m_world.remove(this);
      return;
    }

    recreate();
  }
  
  void recreate() {
    for (int i=0; i<m_shape.length; i++) {
      m_shape[i].transform(-s/2, -s/2, s/2, s/2);
    }
    //Sistemare i vertici dell'oggetto
    outline.transform(-s/2, -s/2, s/2, s/2); 
    
    RPoint[] points = outline.getPoints();

    this.m_vertices = new ArrayList();
    for (int i=0; i<points.length; i++) {
      this.vertex(points[i].x, points[i].y);
    }
    recreateInWorld();
  }
}

