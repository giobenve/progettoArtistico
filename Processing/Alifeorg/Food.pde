
class Food extends FCircle {

  ArrayList orgs;
  color gene0;

  Food(int x, int y) {
    super(8);

    gene0 = color(random(255), random(255), random(255));

    float angle = random(TWO_PI);
    float magnitude = 50;

    //this.setFill(83, 248, 0);   //RGB
    this.setFill(red(gene0), green(gene0), blue(gene0)); 
    this.setPosition(x, y);
    this.setRotation(angle+PI/2);
    this.setVelocity(magnitude*cos(angle), magnitude*sin(angle));
    this.setDamping(0);
    this.setRestitution(0.5);
    //this.setDensity(100);
  }
}



