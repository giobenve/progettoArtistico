
class Food extends FCircle {

  ArrayList orgs;
  color gene0;

  Food(int x, int y, color c) {
    super(8);
    gene0 = c;
    //gene0 = color(random(255), random(255), random(255));

    float angle = random(TWO_PI);
<<<<<<< HEAD
    float magnitude = 0;
=======
    float magnitude = 50;
>>>>>>> 9a732a37fa2b76cdf6d14b76d5266ccd4d313f56

    //this.setFill(83, 248, 0);   //RGB
    this.setFill(red(gene0), green(gene0), blue(gene0)); 
    this.setPosition(x, y);
    this.setRotation(angle+PI/2);
    this.setVelocity(magnitude*cos(angle), magnitude*sin(angle));
    this.setDamping(0);
<<<<<<< HEAD
    this.setRestitution(0);
    this.setDensity(200);
=======
    this.setRestitution(0.5);
    //this.setDensity(100);
>>>>>>> 9a732a37fa2b76cdf6d14b76d5266ccd4d313f56
  }
}

 

