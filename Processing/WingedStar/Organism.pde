
class Organism extends FPoly {
  RShape[] m_shape = new RShape[3];
  String[] files = new String[]{
    "pink.svg", "orange.svg", "rocciaori.svg", "rocciaver.svg"  
  };
  PImage images;
  
  float w = 100;
  float h = 100;  
  
  Organism(int orgid, int x, int y){
    super();
    
    float angle = random(TWO_PI);
    float magnitude = 50;
    
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
    RShape outline = fullSvg.getChild("outline");
    
    if (m_shape == null || outline == null) {
      println("ERROR: Couldn't find the shapes called 'object' and 'outline' in the SVG file.");
      return;
    }
    
    // Make the shapes fit in a rectangle of size (w, h)
    // that is centered in 0
    for (int i=0; i<m_shape.length; i++) {
      m_shape[i].transform(-w/2, -h/2, w/2, h/2);
    }
    //m_shape.transform(-w/2, -h/2, w/2, h/2); 
    outline.transform(-w/2, -h/2, w/2, h/2); 
    
    RPoint[] points = outline.getPoints();

    if (points==null) return;
    
    for (int i=0; i<points.length; i++) {
      this.vertex(points[i].x, points[i].y);
    }

    this.setNoFill();
    this.setNoStroke();
  }
  
  int j = 0;
  
  void draw(PGraphics applet) {
   preDraw(applet);
   
     m_shape[j].draw(applet);
   j = (j + 1 ) % m_shape.length;
   //m_shape.draw(applet);
   postDraw(applet);
  }
  
}
