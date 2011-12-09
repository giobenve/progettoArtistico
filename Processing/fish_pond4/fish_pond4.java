import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class fish_pond4 extends PApplet {

//Nicholas Tang
//3/9/11
int t, numfish, sp = 35, cnum, cnum2;
ArrayList fishes, foods;
PImage scaleTemplate, a;
PGraphics pg, fishskin;
PVector v1,v2,v3,v4,v5;
int[] palette = new int[5];
int c1;

public void setup(){
     //frameRate(45);
     smooth();
     v1 = new PVector();
     v2 = new PVector(); 
     v3 = new PVector();
     v4 = new PVector(); 
     scaleTemplate = loadImage("fishscale.png");
     a = loadImage("background.png");
     a.resize(900,500);
     colorMode(HSB,360);
     palette[0] = color(250, .03f*360, 360); //white
     palette[1] = color(48, .97f*360, 0.98f*360); //yellow
     palette[2] = color(29,0.96f*360,0.94f*360); //orange
     palette[3] = color(352, 360, 0.75f*360); //red
     //palette[4] = color(0,360,0.05*360); // black
     size(900,500,P3D);
     pg = createGraphics(900, 500, P3D);
     numfish = 25;
     t = 0;
     foods = new ArrayList();
     fishes = new ArrayList();
     for (int i = 1; i < numfish+1; i++) {
       fishskin = skin();
       fishes.add(new fish((-width/2)/sp-random(width*1.5f)/sp,-(height/2)/sp+(floor(random(numfish))*(height/numfish))/sp,(3*PI)/2,c1,fishskin));
     }
}

public void draw(){
  pg.beginDraw();
  pg.background(a);
  //pg.background(215,360,115);
  //background(215,360,115);
  colorMode(RGB,255);
  background(255, 255, 251);
  colorMode(HSB,360);
  t = t+1;
  //println(frameRate);
  for (int i = fishes.size()-1; i >= 0; i--) { 
    fish fish1 = (fish) fishes.get(i);
    float fisht = fish1.fisht;
    float randt = fish1.randt;
    fisht = fisht + 1;
    fish1.display(t);
    if (fisht%2 == 0){
      detectfood(fish1,i);
    }
    if (t == 1){
      fish1.nth = fish1.th+signs(random(-0.001f,0.001f))*random(PI/4);
    }
    if ((fisht%(50+randt) == 0) && (fish1.chasingfood == false)){
      fish1.nth = fish1.th+signs(random(-1,1))*random(PI/4);
      fisht = 0;
      randt = round(random(50));
    }
    fish1.fisht = fisht;
    fish1.randt = randt;
    fish1.update();
    if ((fish1.pos[0] > ((width/2)+100)/sp) || (fish1.pos[1] > ((height/2)+100)/sp) || (fish1.pos[1] < -((height/2)+100)/sp)){
      fishes.remove(i);
      fishskin = skin();
      fishes.add(new fish(-(width/2)/sp-random((3*width)/2)/sp-50/sp,-(height/2)/sp+(floor(random(numfish))*(height/numfish))/sp,(3*PI)/2,c1,fishskin));
    }
  }
  pg.endDraw();
  if (mousePressed){
    foods.add(new food(mouseX, mouseY,random(65)));
  }
  water(pg);
}

public float signs(float a){
  if (a > 0){
    return 1;
  } else if (a == 0){
    return 0;
  } else{
    return -1;
  }
}

public PGraphics skin(){
  PGraphics scales;
  scales = createGraphics(98+31-15, PApplet.parseInt(0.2f*((60/8)*3)/.4f*2)+1,P2D);
  c1 = palette[floor(random(3.99f))];
  scales.beginDraw();
  scales.colorMode(HSB,360);
  for (int y = 0; y <= scales.height; y++) {
    scales.stroke(hue(c1),saturation(c1),sqrt(pow(scales.height/2,2)-pow((y-scales.height/2),2))*((360*2)/scales.height));
    scales.line(0,y,scales.width,y);
  }
  scales.endDraw();
  scales.mask(scaleTemplate);
  return scales;
}

public void detectfood(fish fish1, int i){
    float pos1 = fish1.pos[0]*sp+width/2+cos(fish1.th+PI/2)*31;
    float pos2 = fish1.pos[1]*sp+height/2+sin(fish1.th+PI/2)*31;
    int p = 0;
    boolean chasingfood = false;
    float [][] targets = new float[2][128];
    for (int j = foods.size()-1; j >= 0; j--) { 
      food food1 = (food) foods.get(j);
      if (i == fishes.size()-1){
        food1.die = 20;
      }
      if (dist(pos1,pos2,food1.pos[0],food1.pos[1]) < food1.die){
        food1.die = dist(pos1,pos2,food1.pos[0],food1.pos[1]);
      }
      if (food1.die < 10){
        food1.death = true;
      }
      if (food1.death && ((food1.die > 10) || (food1.die < 2))){
        foods.remove(j);
        fish1.dTh = 4*fish1.dx/60;
        fish1.nth = 3*PI/2;
      } else if ((dist(pos1,pos2,food1.pos[0],food1.pos[1]) < 400) && (pos1 < food1.pos[0]) && !((abs(food1.pos[1]-pos2)/abs(food1.pos[0]-pos1) > 2) && (abs(food1.pos[0]-pos1) < 40))){
        if (p < 128){
          targets[0][p] =  food1.pos[0];
          targets[1][p] =  food1.pos[1];
          p += 1;
        }
        if ((fish1.target[0] == food1.pos[0]) && (fish1.target[1] == food1.pos[1])){
          chasingfood = true;
          fish1.dTh = fish1.dx/sqrt(abs(food1.pos[0]-pos1));
          float dth = PVector.angleBetween(new PVector(food1.pos[0]-pos1, food1.pos[1]-pos2), new PVector(cos(fish1.th), sin(fish1.th)));
          if (dth > fish1.dx/5){
            fish1.dTh = fish1.dx/8;
          }
          fish1.nth = (fish1.th+dth-PI/2);
        }
      }
    }
    if ((fish1.chasingfood == true) && (chasingfood == false)){
      fish1.dTh = 4*fish1.dx/60;
      fish1.nth = 3*PI/2;
    }
    fish1.chasingfood = chasingfood;
//    fish1.target[0] = targets[0][floor(random(p))];
//    fish1.target[1] = targets[1][floor(random(p))];
    fish1.target[0] = targets[0][0];
    fish1.target[1] = targets[1][0];
    for (int k = 1; k < p; k++) {
      if (fish1.target[0] > targets[0][k]){
        fish1.target[0] = targets[0][k];
        fish1.target[1] = targets[1][k];
      }
    }
}
//Nicholas Tang
//3/9/11
class fish {
  
  int len = 98;
  float[][] tailPath;
  float[] pos, target;
  float dx = 0.4f/3, th, nth, dTh = 4*dx/60, phi0, fisht, randt;
  int fcolor;
  PGraphics fishskin;
  boolean chasingfood;
  
  fish(float pos1, float pos2, float th1, int fcolor1, PGraphics fishskin1) {
    tailPath = new float[4][len];
    pos = new float[2];
    phi0 = random(2*PI);
    th = th1;
    nth = th;
    for (int i = 1; i < len; i++) {
      tailPath[1][i] = (i-1)*dx*sin(th)+pos1;
      tailPath[2][i] = (i-1)*dx*cos(th)+pos2;
      tailPath[3][i] = th;
    }
    pos[0] = pos1;
    pos[1] = pos2;
    fcolor = fcolor1;
    fishskin = fishskin1;
    fisht = 0;
    randt = round(random(50));
    boolean chasingfood = false;
    target = new float[2];
  }
  
  public void display(float t) {
    int len2 = -31;
    int lenfin = 40;
    float[] y2 = new float[len];
    float[] thickness = new float[len];
    float[] tailR = new float[len];
    float[] tailL = new float[len];
    float[][] pHeadR = new float[3][abs(len2)];
    float[][] pHeadL = new float[3][abs(len2)];
    float[][] pFinR = new float[3][lenfin];
    float[][] pFinL = new float[3][lenfin];
    float[][] pEyeR = new float[3][lenfin];
    float[][] pEyeL = new float[3][lenfin];
    float[][] pTailR = new float[3][len];
    float[][] pTailL = new float[3][len];
    float squareScale = (60/8)*3;
    float phi = t*(PI/15)*(sp/17)+phi0;
    float w = 0.2f*squareScale;
    for (int i = 1; i < len; i++) {
      y2[i] = (squareScale*exp(0.1f/1.25f*((i-1)*dx-30))-squareScale*exp(0.1f/1.25f*(-30)))*cos(0.2f*(i-1)*dx-phi);
      thickness[i] = w*(cos(PI/(len*dx)*(i-1)*dx)+1)*0.5f*PApplet.parseInt((i-1)<len);
      tailR[i] = y2[i] + thickness[i];
      tailL[i] = y2[i] - thickness[i];
      pTailR[1][i] = tailR[i]*cos(tailPath[3][i])+3*tailPath[1][i]-3*pos[0];
      pTailR[2][i] = tailR[i]*sin(tailPath[3][i])+3*tailPath[2][i]-3*pos[1];
      pTailL[1][i] = tailL[i]*cos(tailPath[3][i])+3*tailPath[1][i]-3*pos[0];
      pTailL[2][i] = tailL[i]*sin(tailPath[3][i])+3*tailPath[2][i]-3*pos[1];
    }
    for (int i = 1; i < abs(len2); i++) {
      pHeadR[1][i] = (sqrt(1-pow(((i+len2)*dx),2)/pow(4,2))*w)*cos(th)+3*((i+len2)*dx)*cos(th-PI/2);
      pHeadR[2][i] = (sqrt(1-pow(((i+len2)*dx),2)/pow(4,2))*w)*sin(th)+3*((i+len2)*dx)*sin(th-PI/2);
      pHeadL[1][i] = -(sqrt(1-pow(((i+len2)*dx),2)/pow(4,2))*w)*cos(th)+3*((i+len2)*dx)*cos(th-PI/2);
      pHeadL[2][i] = -(sqrt(1-pow(((i+len2)*dx),2)/pow(4,2))*w)*sin(th)+3*((i+len2)*dx)*sin(th-PI/2);
    }
    float scfin = (PI/3)/lenfin;
    float sceye = (2*PI)/lenfin;
    float ecc = 1.25f;
    float sc = 0.15f*3;
    float eyex = 2.5f*3;
    float eyey = (7*w)/16;
    for (int i = 1; i < lenfin; i++) {
      pFinR[1][i] = w*cos(th)+3*2*sin(3*(i-1)*scfin)*sin((i-1)*scfin+PI/6+PI/2+PI/24-th);
      pFinR[2][i] = w*sin(th)+3*2*sin(3*(i-1)*scfin)*cos((i-1)*scfin+PI/6+PI/2+PI/24-th);
      pFinL[1][i] = -w*cos(th)+3*2*sin(3*(i-1)*scfin)*sin((i-1)*scfin+PI/6+PI/3+PI/2-PI/24-th); 
      pFinL[2][i] = -w*sin(th)+3*2*sin(3*(i-1)*scfin)*cos((i-1)*scfin+PI/6+PI/3+PI/2-PI/24-th);
      pEyeR[1][i] = eyey*cos(th)+eyex*sin(-th)+sc*(ecc*sin((i-1)*sceye)*cos(th+PI/2)-cos((i-1)*sceye)*sin(th+PI/2)); 
      pEyeR[2][i] = eyey*sin(th)+eyex*cos(-th)+sc*(cos(th+PI/2)*cos((i-1)*sceye)+ecc*sin((i-1)*sceye)*sin(th+PI/2));
      pEyeL[1][i] = -eyey*cos(th)+eyex*sin(-th)+sc*(ecc*sin((i-1)*sceye)*cos(th+PI/2)-cos((i-1)*sceye)*sin(th+PI/2)); 
      pEyeL[2][i] = -eyey*sin(th)+eyex*cos(-th)+sc*(cos(th+PI/2)*cos((i-1)*sceye)+ecc*sin((i-1)*sceye)*sin(th+PI/2));
    }
    pg.colorMode(HSB,360);
    pg.pushMatrix();
    pg.translate(width/2+sp*pos[0],height/2+sp*pos[1]);
    
    pg.fill(color(hue(fcolor),saturation(fcolor)-50,brightness(fcolor),300));
    pg.stroke(color(hue(fcolor),saturation(fcolor)-50,brightness(fcolor),300));
    drawShape(lenfin,pFinR);
    drawShape(lenfin,pFinL);
    pg.noStroke();
    pg.beginShape(TRIANGLE_STRIP);
    pg.texture(fishskin);
    for (int i = 1; i < abs(len2); i++) {
      pg.vertex(pHeadL[1][i]/.4f,pHeadL[2][i]/.4f,fishskin.width-i,fishskin.height);
      pg.vertex(pHeadR[1][i]/.4f,pHeadR[2][i]/.4f,fishskin.width-i,0);
    }
    for (int i = 1; i <= len-15; i++) {
      pg.vertex(pTailL[1][i]/.4f,pTailL[2][i]/.4f,fishskin.width-(i-1+abs(len2)),fishskin.height);
      pg.vertex(pTailR[1][i]/.4f,pTailR[2][i]/.4f,fishskin.width-(i-1+abs(len2)),0);
    }
    pg.endShape();
    pg.beginShape();
    for (int i = len-15; i < len; i++) {
      pg.vertex(pTailR[1][i]/.4f,pTailR[2][i]/.4f);
    }
    for (int i = len-1; i > len-1-15; i--) {
      pg.vertex(pTailL[1][i]/.4f,pTailL[2][i]/.4f);
    }
    pg.endShape();
    pg.fill(0);
    pg.stroke(0);
    drawShape(lenfin,pEyeR);
    drawShape(lenfin,pEyeL);
    pg.popMatrix();
  }
  
  public void update() {
    float diffth = nth-th;
    diffth = diffth%(2*PI);
    if (sign(diffth) == -1){
      diffth = diffth+2*PI;
    }
    if (diffth > PI){
      diffth = diffth-2*PI;
    }
    if (abs(diffth)>abs(dTh)){
        th = th + sign(diffth)*dTh;
    }
    pos[0] = pos[0]+dx*cos(th+PI/2);
    pos[1] = pos[1]+dx*sin(th+PI/2);
    float[][] newtailPath = new float[4][len];
    newtailPath[1][1] = pos[0];
    newtailPath[2][1] = pos[1];
    newtailPath[3][1] = th;
    for (int i = 1; i < len-1; i++) {
      newtailPath[1][i+1] = tailPath[1][i];
      newtailPath[2][i+1] = tailPath[2][i];
      newtailPath[3][i+1] = tailPath[3][i];
    }
    tailPath = newtailPath;
  }
}

public void drawShape(int len, float[][] shapes){
  pg.beginShape();
  for (int i = 1; i < len; i++) {
    pg.vertex(shapes[1][i]/.4f,shapes[2][i]/.4f);
  }
  pg.endShape();
}

public float sign(float a){
  if (a > 0){
    return 1;
  } else if (a == 0){
    return 0;
  } else{
    return -1;
  }
}
//Nicholas Tang
//3/9/11
class food {
  float[] pos;
  float foodcolor1;
  float die;
  boolean death;
  
  food(float pos1, float pos2, float foodcolor) {
    pos = new float[2];
    pos[0] = pos1;
    pos[1] = pos2;
    foodcolor1 = foodcolor;
    die = 20;
    death = false;
  }
}
//Nicholas Tang
//3/9/11
int gridSize=20;
float xoff,zoff,ns=0.25f,zs=130,power = 2.5f;
PImage tex;

public void water(PGraphics tex) {
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
  noiseDetail(8,200*(0.6f/height));
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
    fill(food1.foodcolor1,.9f*360,.55f*360);
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
    
  zoff+=0.045f;
  xoff-=0.06f;
    
}

public void surfnorm(int x, int y, float nx, float ny){
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
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#EBE9ED", "fish_pond4" });
  }
}
