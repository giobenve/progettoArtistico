//Nicholas Tang
//3/9/11
int gridSize=20;
float xoff,zoff,ns=0.25,zs=130,power = 2.5;
PImage tex;

void water(PGraphics tex) {
//  if ((mouseX == 0) && (mouseY == 0)){
//    camera(width/2, height/2-60+270/1.85, 520-270/50-(250-width/2+300)/3.5, width/2, height/2, 0.0, -0.0, 1.0, 0.0);
//  } else{
//  camera(width/2, height/2-60+mouseY/1.85, 520-mouseY/50-(mouseX-width/2+400)/1.67, // eyeX, eyeY, eyeZ
//         width/2, height/2, 0.0, // centerX, centerY, centerZ
//         -0.0, 1.0, 0.0); // upX, upY, upZ
//  }
  noStroke();
  image(tex,0,0);
  
  colorMode(RGB, 255);
  pointLight(255, 255, 255, width, height/2, 100);
  pointLight(255, 255, 255, width/2, height, 100);
  ambientLight(30, 30, 30);
  lightSpecular(95, 95, 95);
  directionalLight(115, 115, 115, 1, 1, -1);
  directionalLight(115, 115, 115, -1, -1, -1);
  specular(255, 255, 255);
  shininess(50);
  spotLight(45, 45, 45, -100, 230, 800, 1, 0, -1, PI/3, 5);
  colorMode(HSB, 360);
  noiseDetail(8,200*(0.6/height));
  float nx,ny=0,z1,z2;
  
  fill(255,0,0,75);
  for(int y=0; y<=height+gridSize; y+=gridSize) {
    nx=xoff;
    beginShape(TRIANGLE_STRIP);
    //texture(fg);
    for(int x=0; x<width+gridSize; x+=gridSize) {
      z1=pow(noise(nx,ny,zoff),power);
      z2=pow(noise(nx,ny+ns,zoff),power);
      surfnorm(x,y,nx,ny);
      normal(v5.x,v5.y,v5.z);
      vertex(x,y,z1*zs);
      surfnorm(x,y+gridSize,nx,ny+ns);
      normal(v5.x,v5.y,v5.z);
      vertex(x,y+gridSize,z2*zs);
      nx+=ns;
    }
    endShape();
    ny+=ns;
  }
  
  
  for (int i = foods.size()-1; i >= 0; i--) { 
    food food1 = (food) foods.get(i);
    pushMatrix();
    //translate(food1.pos[0],food1.pos[1],pow(noise(ns*(food1.pos[0]/gridSize)+xoff,ns*(food1.pos[1]/gridSize),zoff),power)*zs);
    translate(0,0,pow(noise(ns*(food1.pos[0]/gridSize)+xoff,ns*(food1.pos[1]/gridSize),zoff),power)*zs);
    fill(food1.foodcolor1,.9*360,.55*360);
    if (food1.death){
      ellipse(food1.pos[0]-2,food1.pos[1]-2,4,4);
//      sphereDetail(2);
//      sphere(2);
    } else{
      ellipse(food1.pos[0]-3,food1.pos[1]-3,6,6);
//      sphereDetail(3);
//      sphere(3.5);
    }
    popMatrix();
  }
    
  zoff+=0.045;
  xoff-=0.06;
    
}

void surfnorm(int x, int y, float nx, float ny){
  float z0 = pow(noise(nx,ny,zoff),power);
  float z1 = pow(noise(nx,ny+ns,zoff),power);
  float z2 = pow(noise(nx+ns,ny,zoff),power);
  float z3 = pow(noise(nx,ny-ns,zoff),power);
  float z4 = pow(noise(nx-ns,ny,zoff),power);
  v1.set(0, gridSize, (z1-z0)*zs);
  v2.set(gridSize, 0, (z2-z0)*zs);
  v3.set(0, -gridSize, (z3-z0)*zs);
  v4.set(-gridSize, 0, (z4-z0)*zs);
  v5 = PVector.add(PVector.add(v1.cross(v2),v2.cross(v3)),PVector.add(v3.cross(v4),v4.cross(v1)));
  v5.normalize();
}
