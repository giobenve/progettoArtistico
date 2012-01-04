
class Stone extends FPoly {
  
  Stone(){
    super();
    
    float angle = random(TWO_PI);
    float magnitude = 50;
    
    this.setStrokeWeight(3);
    this.setFill(102, 102, 102);
    this.setDensity(10);
    this.setRestitution(0);
    this.setStaticBody(true);
    }
  
 
  
}

