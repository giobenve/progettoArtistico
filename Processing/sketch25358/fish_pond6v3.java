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

public class fish_pond6v3 extends PApplet {

//Nicholas Tang
//3/25/11
int t, numfish, cnum, cnum2, sp10 = 35, period, gwidth, gheight;
ArrayList fishes, foods;
PImage scaleTemplate;
PImage caustics[];
PGraphics pg, fishskin;
PGraphics[] causticss;
PVector v1,v2,v3,v4,v5;
int[] palette = new int[5], palette2 = new int[5];
float increment = 0.075f, zrand, invprec;
boolean leavechasing;
float[] sinTable, cosTable;
float[][] z, dz;

public void setup() {
  frameRate(17);
  v1 = new PVector();
  v2 = new PVector(); 
  v3 = new PVector();
  v4 = new PVector(); 
  gwidth = (width/gridSize)+1;
  gheight = height/gridSize;
  z = new float[gwidth][gheight];
  dz = new float[gwidth][gheight];
  invprec = 1000;
  period = PApplet.parseInt(360*invprec);
  sinTable = new float[period*2];
  cosTable = new float[period*2];
  for (int i = 0; i < period*2; i ++) {
    sinTable[i] = sin(radians(i/invprec));
    cosTable[i] = cos(radians(i/invprec));
  }
  scaleTemplate = loadImage("fishscale.png");
  colorMode(HSB,360);
  palette[0] = color(0,360,0.05f*360); // black
  palette[1] = color(250, .03f*360, 360); //white
  palette[2] = color(352, 360, 0.75f*360); //red
  palette[3] = color(48, .97f*360, 0.98f*360); //yellow
  palette[4] = color(29,0.96f*360,0.94f*360); //orange
  for (int i = 0; i < 5; i++) {
    palette2[i] = color(hue(palette[i]), saturation(palette[i])-50, brightness(palette[i]), 300);
  }
  leavechasing = false;
  size(900,500,P3D);
  pg = createGraphics(900, 500, P3D);
  numfish = 25;
  t = 0;
  foods = new ArrayList();
  fishes = new ArrayList();
  for (int i = 1; i < numfish+1; i++) {
    fishskin = skin();
    fishes.add(new fish((-width/2)-random(width*1.5f),-(height/2)+(floor(random(numfish))*(height/numfish)),(3*PI)/2,cnum2,fishskin));
  }
  caustics = new PImage[30];
  causticss = new PGraphics[30];
  for (int i = 0; i < 30; i ++) {
    caustics[i] = loadImage("caustics_" + nf(i+1,3) + ".bmp");
    caustics[i].resize(450,500);
    causticss[i] = seam(caustics[i],i);
  }
}

public void draw() {
  pg.beginDraw();
  pg.background(causticss[t%30]);
  //pg.background(215,360,175);
  t ++;
  //println(frameRate);
  for (int i = fishes.size()-1; i >= 0; i--) { 
    fish fish1 = (fish) fishes.get(i);
    float fisht = fish1.fisht;
    float randt = fish1.randt;
    fisht ++;
    fish1.display();
    if (fisht%2 == 0) {
      detectfood(fish1,i);
    }
    //    if (t == 1){
    //      fish1.updateangle(fish1.th+sign(random(-0.001,0.001))*random(PI/4));
    //    }
    if ((fisht%(5+randt) == 0) && (fish1.chasingfood == false)) {
      if (leavechasing) {
        fish1.updateangle(3*PI/2+sign(sinLUT(t))*random(PI/12));
        leavechasing = false;
      } 
      else {
        fish1.updateangle(fish1.th+sign(sinLUT(t))*random(PI/12));
      }
      fisht = 0;
      randt = round(random(70));
    }
    fish1.fisht = fisht;
    fish1.randt = randt;
    fish1.update();
    if ((fish1.pos.x > ((width/2)+100)) || (fish1.pos.y > ((height/2)+100)) || (fish1.pos.y < -((height/2)+100))) {
      fishes.remove(i);
      fishskin = skin();
      fishes.add(new fish(-(width/2)-random((3*width)/2)-50,-(height/2)+(floor(random(numfish))*(height/numfish)),(3*PI)/2,cnum2,fishskin));
    }
  }
  pg.endDraw();
  if (mousePressed) {
    foods.add(new food(mouseX, mouseY,random(65)));
    ripple(mouseX, mouseY, pmouseX, pmouseY);
  }
  water(pg);
}

public float sign(float a) {
  if (a > 0) {
    return 1;
  } 
  else if (a == 0) {
    return 0;
  } 
  else {
    return -1;
  }
}

public PGraphics skin() {
  int c1, c2, c1n, c2n;
  cnum = floor(random(4.99f));
  cnum2 = floor(random(3.99f)+1);
  if ((cnum2 > 1) && (cnum > 1)) {
    if (PApplet.parseBoolean(round(random(1)))) {
      cnum2 = cnum;
    } 
    else {
      if (cnum == 2){
        cnum2 = 1;
      } else{
        cnum = 1;
      }
    }
  }
  if ((cnum == 1) && (cnum2 > 2)) {
    cnum2 = 2;
  }
  if ((cnum2 == 1) && (cnum > 1)) {
    //cnum = 1+round(random(1));
    cnum = 2;
  }
  c1n = palette[cnum];
  c2n = palette[cnum2];
  PGraphics scales = createGraphics(98+31-15, PApplet.parseInt(0.2f*((60/8)*3)/.4f*2)+1,P2D);
  noiseDetail(2,1.5f);
  scales.loadPixels();
  float yoff = 0.0f;
  for (int y = 0; y < scales.height; y++) {
    yoff += increment;
    float xoff = 0.0f;
    float b2lim = 0.6f;
    if (cnum != 0) {
      c1 = color(hue(c1n),saturation(c1n),sqrt(pow(scales.height/2,2)-pow((y-scales.height/2),2))*((360*2)/scales.height));
    } 
    else {
      c1 = c1n;
    }
    c2 = color(hue(c2n),saturation(c2n),sqrt(pow(scales.height/2,2)-pow((y-scales.height/2),2))*((360*2)/scales.height));
    for (int x = 0; x < scales.width; x++) {
      xoff += increment;
      int bright = PApplet.parseInt(noise(xoff,yoff,zrand) > 0.6f);
      int bright2 = PApplet.parseInt(noise(xoff,yoff,zrand) > b2lim);
      if (x<98-15-8) {
        scales.pixels[x+y*scales.width] = c1*PApplet.parseInt(bright==1) + c2*PApplet.parseInt(bright==0);
        //scales.pixels[x+y*scales.width] = c1;
      } 
      else {
        scales.pixels[x+y*scales.width] = c1*PApplet.parseInt(bright2==1) + c2*PApplet.parseInt(bright2==0);
        //scales.pixels[x+y*scales.width] = c2;
        b2lim += 0.014f;
      }
    }
  }
  zrand +=PI;
  scales.mask(scaleTemplate);
  return scales;
}

public void detectfood(fish fish1, int i) {
  PVector pos = new PVector(fish1.pos.x+width/2+cosLUT(fish1.th+PI/2)*31,fish1.pos.y+height/2+sinLUT(fish1.th+PI/2)*31);
  int p = 0;
  boolean chasingfood = false;
  float [][] targets = new float[2][128];
  for (int j = foods.size()-1; j >= 0; j--) { 
    food food1 = (food) foods.get(j);
    if (i == fishes.size()-1) {
      food1.die = 20;
    }
    if (PVector.dist(pos,food1.pos) < food1.die) {
      food1.die = PVector.dist(pos,food1.pos);
    }
    if (food1.die < 10) {
      food1.death = true;
    }
    if (food1.death && ((food1.die > 10) || (food1.die < 2))) {
      //ripple(int(food1.pos.x),int(food1.pos.y),int(food1.pos.x),int(food1.pos.y));
      foods.remove(j);
      fish1.nsp = sp10;
      fish1.fisht = fish1.randt;
      leavechasing = true;
    } 
    else if ((PVector.dist(pos,food1.pos) < 350) && (pos.x < food1.pos.x) && !((abs(food1.pos.y-pos.y)/abs(food1.pos.x-pos.x) > 3) && (abs(food1.pos.x-pos.x) < 40))) {
      if (p < 128) {
        targets[0][p] =  food1.pos.x;
        targets[1][p] =  food1.pos.y;
        p += 1;
      }
      if ((fish1.target.x == food1.pos.x) && (fish1.target.y == food1.pos.y)) {
        chasingfood = true;
        fish1.nsp = 75*fish1.sz/3;
        //        float posth = -fish1.sp1*fish1.dx*((fish1.sp1-sp10)/fish1.acc)+((fish1.acc*fish1.dx)/2)*pow((fish1.sp1-sp10)/fish1.acc,2);
        //        if (PVector.dist(pos,food1.pos) < -posth){
        //          fish1.nsp = sp10;
        //        }
        float dth = PVector.angleBetween(PVector.sub(food1.pos,pos), new PVector(cosLUT(fish1.th), sinLUT(fish1.th)));
        fish1.updateangle(fish1.th+dth-PI/2);
      }
    }
  }
  if ((fish1.chasingfood == true) && (chasingfood == false)) {
    fish1.nsp = sp10;
    fish1.fisht = fish1.randt;
    leavechasing = true;
  }
  fish1.chasingfood = chasingfood;
  //  fish1.target.x = targets[0][floor(random(p))];
  //  fish1.target.x = targets[1][floor(random(p))];
  fish1.target.x = targets[0][0];
  fish1.target.y = targets[1][0];
  for (int k = 1; k < p; k++) {
    if (fish1.target.x > targets[0][k]) {
      fish1.target.x = targets[0][k];
      fish1.target.y = targets[1][k];
    }
  }
}

public float sinLUT(float rad) {
  return sinTable[(PApplet.parseInt(degrees(rad)*invprec) % period) + period];
}

public float cosLUT(float rad) {
  return cosTable[(PApplet.parseInt(degrees(rad)*invprec) % period) + period];
}

public PGraphics seam(PImage inp, int i) {
  PGraphics ret = createGraphics(width, height, P2D);
  ret.beginDraw();
  //-inp.width+int(i*(inp.width*1./60))
  for(int j=0; j<=width; j+=inp.width) {
    ret.copy(inp,0,0,inp.width,inp.height,j,0,inp.width,inp.height);
  }
  ret.endDraw();
  return ret;
}


//Nicholas Tang
//3/25/11
class fish {

  int len = 98, sp1, cp = 7, r = PApplet.parseInt(len/(cp-1));
  float[][] tailPath, cpoints;
  PVector pos, target, npos, vel;
  float dx = 0.4f/3, th, vth, fisht, randt, ath, halfth, nth1, vth0 = 4*dx/60, acc, nsp, twist, newth, phi0, twist0, sz;
  int fcolor;
  PGraphics fishskin;
  boolean chasingfood;

  fish(float pos1, float pos2, float th1, int fcolor1, PGraphics fishskin1) {
    sp1 = sp10;
    //sz = 3 + 0.3*sqrt(2*log(1/(1-random(1))));
    sz = 3.35f + 0.225f*sqrt(-2*log(random(1)))*sinLUT(TWO_PI*random(1));
    phi0 = random(TWO_PI);
    twist0 = 0;
    tailPath = new float[3][len];
    cpoints = new float[3][cp];
    pos = new PVector(pos1, pos2);
    npos = new PVector(pos1/sp1, pos2/sp1);
    vel = new PVector();
    th = th1;
    halfth = 0;
    nth1 = th;
    for (int i = 0; i < len; i++) {
      tailPath[0][i] = i*dx*sinLUT(th)+pos1/sp1;
      tailPath[1][i] = i*dx*cosLUT(th)+pos2/sp1;
      tailPath[2][i] = th;
    }
    for (int i = 0; i < cp; i++) {
      cpoints[0][i] = i*dx*sinLUT(th)+pos1/sp1;
      cpoints[1][i] = i*dx*cosLUT(th)+pos2/sp1;
      cpoints[2][i] = th;
    }
    fcolor = fcolor1;
    fishskin = fishskin1;
    fisht = 0;
    randt = round(random(50));
    boolean chasingfood = false;
    target = new PVector();
    vth = vth0;
    ath = dx/45;
    acc = 2;
    nsp = sp1;
  }

  public void display() {
    int len2 = -31;
    int lenfin = 40;
    float[] y2 = new float[len];
    float[] thickness = new float[len];
    float[] tailR = new float[len];
    float[] tailL = new float[len];
    float[][] pHeadR = new float[2][abs(len2)];
    float[][] pHeadL = new float[2][abs(len2)];
    float[][] pFinR = new float[2][lenfin];
    float[][] pFinL = new float[2][lenfin];
    float[][] pEyeR = new float[2][lenfin];
    float[][] pEyeL = new float[2][lenfin];
    float[][] pTailR = new float[2][len];
    float[][] pTailL = new float[2][len];
    float squareScale = (60/8)*sz;
    float w = 0.22f*squareScale;
    float s = 1;
    newth = atan2((sz/s)*abs(len2)*dx*cosLUT(-th)+sz*twist*sinLUT(th),(sz/s)*abs(len2)*dx*sinLUT(-th)+sz*twist*cosLUT(th))+3*HALF_PI;
    for (int i = 0; i < len-10; i++) {
      y2[i] = (squareScale*exp(0.1f/1.25f*(i*dx-30))-squareScale*exp(0.1f/1.25f*(-30)));
      thickness[i] = w*(cosLUT(PI/(len*dx)*i*dx)+1)*0.5f*PApplet.parseInt(i<len);
      tailR[i] = y2[i] + thickness[i];
      tailL[i] = y2[i] - thickness[i];
      pTailR[0][i] = tailR[i]*cosLUT(tailPath[2][i])+sz*tailPath[0][i]-sz*npos.x;
      pTailR[1][i] = tailR[i]*sinLUT(tailPath[2][i])+sz*tailPath[1][i]-sz*npos.y;
      pTailL[0][i] = tailL[i]*cosLUT(tailPath[2][i])+sz*tailPath[0][i]-sz*npos.x;
      pTailL[1][i] = tailL[i]*sinLUT(tailPath[2][i])+sz*tailPath[1][i]-sz*npos.y;
    }
    for (int i = 0; i < abs(len2); i++) {
      pHeadR[0][i] = -sz*twist*cosLUT(th)+(sqrt(1-pow((((i+1)+len2)*dx),2)/pow(4,2))*w)*cosLUT(newth)+sz*(((i+1)+len2)*dx)*cosLUT(newth-HALF_PI);
      pHeadR[1][i] = -sz*twist*sinLUT(th)+(sqrt(1-pow((((i+1)+len2)*dx),2)/pow(4,2))*w)*sinLUT(newth)+sz*(((i+1)+len2)*dx)*sinLUT(newth-HALF_PI);
      pHeadL[0][i] = -sz*twist*cosLUT(th)-(sqrt(1-pow((((i+1)+len2)*dx),2)/pow(4,2))*w)*cosLUT(newth)+sz*(((i+1)+len2)*dx)*cosLUT(newth-HALF_PI);
      pHeadL[1][i] = -sz*twist*sinLUT(th)-(sqrt(1-pow((((i+1)+len2)*dx),2)/pow(4,2))*w)*sinLUT(newth)+sz*(((i+1)+len2)*dx)*sinLUT(newth-HALF_PI);
    }
    float scfin = (PI/3)/lenfin;
    float sceye = (TWO_PI)/lenfin;
    float ecc = 1.25f;
    float sc = 0.15f*sz;
    float eyex = 2.5f*sz;
    float eyey = (7*w)/16;
    for (int i = 0; i < lenfin; i++) {
      pFinR[0][i] = -sz*twist*cosLUT(th)+2*sinLUT(-newth)+w*cosLUT(newth)+sz*2*sinLUT(3*i*scfin)*sinLUT(i*scfin+PI/6+HALF_PI+PI/24-newth);
      pFinR[1][i] = -sz*twist*sinLUT(th)+2*cosLUT(-newth)+w*sinLUT(newth)+sz*2*sinLUT(3*i*scfin)*cosLUT(i*scfin+PI/6+HALF_PI+PI/24-newth);
      pFinL[0][i] = -sz*twist*cosLUT(th)+2*sinLUT(-newth)-w*cosLUT(newth)+sz*2*sinLUT(3*i*scfin)*sinLUT(i*scfin+PI/6+PI/3+HALF_PI-PI/24-newth); 
      pFinL[1][i] = -sz*twist*sinLUT(th)+2*cosLUT(-newth)-w*sinLUT(newth)+sz*2*sinLUT(3*i*scfin)*cosLUT(i*scfin+PI/6+PI/3+HALF_PI-PI/24-newth);
      pEyeR[0][i] = -sz*twist*cosLUT(th)+eyey*cosLUT(newth)+eyex*sinLUT(-newth)+sc*(ecc*sinLUT(i*sceye)*cosLUT(newth+HALF_PI)-cosLUT(i*sceye)*sinLUT(newth+HALF_PI)); 
      pEyeR[1][i] = -sz*twist*sinLUT(th)+eyey*sinLUT(newth)+eyex*cosLUT(-newth)+sc*(cosLUT(newth+HALF_PI)*cosLUT(i*sceye)+ecc*sinLUT(i*sceye)*sinLUT(newth+HALF_PI));
      pEyeL[0][i] = -sz*twist*cosLUT(th)-eyey*cosLUT(newth)+eyex*sinLUT(-newth)+sc*(ecc*sinLUT(i*sceye)*cosLUT(newth+HALF_PI)-cosLUT(i*sceye)*sinLUT(newth+HALF_PI)); 
      pEyeL[1][i] = -sz*twist*sinLUT(th)-eyey*sinLUT(newth)+eyex*cosLUT(-newth)+sc*(cosLUT(newth+HALF_PI)*cosLUT(i*sceye)+ecc*sinLUT(i*sceye)*sinLUT(newth+HALF_PI));
    }
    pg.pushMatrix();
    pg.translate(width/2+pos.x,height/2+pos.y);
    pg.fill(palette2[fcolor]);
    pg.stroke((palette2[fcolor] & 0xffffff) | (89 << 24));
    drawShape(lenfin,pFinR);
    drawShape(lenfin,pFinL);
    pg.fill((palette2[fcolor] & 0xffffff) | (142 << 24));
    pg.noStroke();
    pg.beginShape(TRIANGLE_STRIP);
    pg.texture(fishskin);
    for (int i = 0; i < abs(len2); i++) {
      pg.vertex(pHeadL[0][i]/.4f,pHeadL[1][i]/.4f,fishskin.width-i,fishskin.height);
      pg.vertex(pHeadR[0][i]/.4f,pHeadR[1][i]/.4f,fishskin.width-i,0);
    }
    for (int i = 0; i <= len-15-10; i++) {
      pg.vertex(pTailL[0][i]/.4f,pTailL[1][i]/.4f,fishskin.width-(i-1+abs(len2)),fishskin.height);
      pg.vertex(pTailR[0][i]/.4f,pTailR[1][i]/.4f,fishskin.width-(i-1+abs(len2)),0);
    }
    pg.endShape();
    pg.beginShape();
    for (int i = len-15-10; i < len-10; i++) {
      pg.vertex(pTailR[0][i]/.4f,pTailR[1][i]/.4f);
    }
    for (int i = len-1-10; i > len-1-15-10; i--) {
      pg.vertex(pTailL[0][i]/.4f,pTailL[1][i]/.4f);
    }
    pg.endShape();
    pg.fill(0);
    pg.stroke(0);
    drawShape(lenfin,pEyeR);
    drawShape(lenfin,pEyeL);
    pg.popMatrix();

    if (chasingfood) {
      if (nsp > sp1) {
        twist0+=0.07f;
      } 
      else {
        twist0-=0.05f;
      }
      twist0 = constrain(twist0,0,0.3f);
      twist = twist0*sinLUT(t*(QUARTER_PI)+phi0);
    } 
    else {
      if ((abs(nsp-sp1)<10) && (fisht > 5+randt - 6)) {
        twist0+=0.05f;
      } 
      else {
        twist0-=0.005f;
      }
      twist0 = constrain(twist0,0,0.4f);
      twist = twist0*sinLUT(t*(PI/10)+phi0);
    }
    //twist = twist0*sinLUT(t*(PI/(4+(abs(nsp-75)/10)))+phi0);
  }

  public void update() {
    updateangle(nth1);
    updatespeed();
    npos.x += dx*cosLUT(th+HALF_PI);
    npos.y += dx*sinLUT(th+HALF_PI);
    float[][] newcpoints = new float[3][cp];
    newcpoints[0][0] = npos.x-twist*cosLUT(th);
    newcpoints[1][0] = npos.y-twist*sinLUT(th);
    newcpoints[2][0] = newth;
    for (int i = 0; i < cp-1; i++) {
      newcpoints[0][i+1] = cpoints[0][i] + dx*r*cosLUT((cpoints[2][i]+cpoints[2][i+1])/2-HALF_PI);
      newcpoints[1][i+1] = cpoints[1][i] + dx*r*sinLUT((cpoints[2][i]+cpoints[2][i+1])/2-HALF_PI);
      newcpoints[2][i+1] = cpoints[2][i];
    }
    cpoints = newcpoints;
    for (int i = 0; i < cp-1; i++) {
      tailPath[0][i*r] = cpoints[0][i];
      tailPath[1][i*r] = cpoints[1][i];
      tailPath[2][i*r] = cpoints[2][i];
      for (int j = 1; j < r; j++) {
        tailPath[0][i*r+j] = curvePoint(cpoints[0][max(i-1,0)],cpoints[0][i],cpoints[0][i+1],cpoints[0][min(i+2,cp-1)],j*1.f/r);
        tailPath[1][i*r+j] = curvePoint(cpoints[1][max(i-1,0)],cpoints[1][i],cpoints[1][i+1],cpoints[1][min(i+2,cp-1)],j*1.f/r);
        tailPath[2][i*r+j] = atan2(curveTangent(cpoints[1][max(i-1,0)],cpoints[1][i],cpoints[1][i+1],cpoints[1][min(i+2,cp-1)],j*1.f/r),
        curveTangent(cpoints[0][max(i-1,0)],cpoints[0][i],cpoints[0][i+1],cpoints[0][min(i+2,cp-1)],j*1.f/r))+HALF_PI;
      }
    }
  }

  public void updateangle(float nth) {
    float diffth = nth-th;
    if (sign(nth1-th) != sign(diffth)) {
      vth = vth0;
    }
    nth1 = nth;
    halfth = -vth*((vth-vth0)/ath)+(ath/2)*pow((vth-vth0)/ath,2);
    if (abs(diffth) > abs(vth)) {
      if (abs(diffth) > abs(halfth)) {
        vth += ath;
      } 
      else {
        vth -= ath;
      }
      vth = max(vth, vth0);
      th += sign(diffth)*vth;
    } 
    else {
      th += diffth;
      vth = vth0;
    }
  }
  public void updatespeed() {
    float diffsp = nsp - sp1;
    if (abs(diffsp) > acc) {
      if (sign(diffsp) == 1) {
//        ripple(int(pos.x+width/2+cosLUT(th+HALF_PI)*31),int(pos.y+height/2+sinLUT(th+HALF_PI)*31),
//        int(pos.x+width/2+cosLUT(th+HALF_PI)*31),int(pos.y+height/2+sinLUT(th+HALF_PI)*31));
        sp1 += acc*2;
      } 
      else {
        sp1 -= acc;
      }
    } 
    else {
      sp1 += diffsp;
    }
    vel.set(sp1*dx*cosLUT(th+HALF_PI), sp1*dx*sinLUT(th+HALF_PI),0);
    pos.add(vel);
  }
}

public void drawShape(int len, float[][] shapes) {
  pg.beginShape();
  for (int i = 0; i < len; i++) {
    pg.vertex(shapes[0][i]/.4f,shapes[1][i]/.4f);
  }
  pg.endShape();
}

//Nicholas Tang
//3/25/11
class food {
  PVector pos;
  float foodcolor1;
  float die;
  boolean death;

  food(float pos1, float pos2, float foodcolor) {
    pos = new PVector(pos1, pos2);
    foodcolor1 = foodcolor;
    die = 20;
    death = false;
  }
}

//Nicholas Tang
//3/25/11
int gridSize=20;
float xoff,zoff,ns=0.25f,zs=130,power = 2.5f, avgz, impulse = -0.5f;
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
  background(tex);
  updatez();

  colorMode(RGB, 255);
  if (t == 1) {
    specular(255, 255, 255);
    shininess(50);
  }
  pointLight(255, 255, 255, width, height/2, 100);
  pointLight(255, 255, 255, width/2, height, 100);
  ambientLight(30, 30, 30);
  lightSpecular(95, 95, 95);
  directionalLight(115, 115, 115, 1, 1, -1);
  directionalLight(115, 115, 115, -1, -1, -1);
  spotLight(45, 45, 45, -100, 230, 800, 1, 0, -1, PI/3, 5);
  noiseDetail(8,200*(0.6f/height));
  float nx,ny=0,z1,z2;
  colorMode(HSB, 360);
  
  fill(255,0,0,75);
  for(int y=0; y<gheight; y++) {
    nx=xoff;
    beginShape(TRIANGLE_STRIP);
    for(int x=0; x<gwidth; x++) {
      z1=pow(noise(nx,ny,zoff),power);
      z2=pow(noise(nx,ny+ns,zoff),power);
      surfnorm(x,y,nx,ny);
      normal(v5.x,v5.y,v5.z);
      vertex(x*gridSize,y*gridSize);
      surfnorm(x,y+1,nx,ny+ns);
      normal(v5.x,v5.y,v5.z);
      vertex(x*gridSize,(y+1)*gridSize);
      nx+=ns;
    }
    endShape();
    ny+=ns;
  }

  for (int i = foods.size()-1; i >= 0; i--) { 
    food food1 = (food) foods.get(i);
    pushMatrix();
    translate(0,0,z[PApplet.parseInt(constrain(food1.pos.x,0,gwidth-2)/gridSize)][PApplet.parseInt(constrain(food1.pos.y,0,gheight-2)/gridSize)]*50+pow(noise(ns*(food1.pos.x/gridSize)+xoff,ns*(food1.pos.y/gridSize),zoff),power)*zs);
    fill(food1.foodcolor1,.9f*360,.55f*360);
    ellipseMode(CENTER);
    if (food1.death) {
      ellipse(food1.pos.x,food1.pos.y,4,4);
      //      sphereDetail(2);
      //      sphere(2);
    } 
    else {
      ellipse(food1.pos.x,food1.pos.y,6,6);
      //      sphereDetail(3);
      //      sphere(3.5);
    }
    popMatrix();
  }

  zoff+=0.045f;
  xoff-=0.06f;
}

public void updatez() {
  for(int x=1; x<gwidth-1; x++) {
    for(int y=1; y<gheight-1; y++) {
      avgz = (z[x-1][y] + z[x+1][y] + z[x][y-1] + z[x][y+1])*0.25f;
      dz[x][y] += (avgz - z[x][y])*2;
      dz[x][y] *= 0.9f;
    }
  }
  for(int x=1; x<gwidth-1; x++) {
    for(int y=1; y<gheight-1; y++) {
      z[x][y] += dz[x][y];
    }
  }
}

public void ripple(int x0, int y0, int x1, int y1) {
  x0 = constrain(x0/gridSize, 0, gwidth-2);
  y0 = constrain(y0/gridSize, 0, gheight-2);
  x1 = constrain(x1/gridSize, 0, gwidth-2);
  y1 = constrain(y1/gridSize, 0, gheight-2);
  int xi = 0, yi = 0;
  for (int i=0; i<=PApplet.parseInt(dist(x0,y0,x1,y1)); i++) {
    xi = PApplet.parseInt(x0+(i/max(1,PApplet.parseFloat(PApplet.parseInt(dist(x0,y0,x1,y1)))))*(x1-x0));
    yi = PApplet.parseInt(y0+(i/max(1,PApplet.parseFloat(PApplet.parseInt(dist(x0,y0,x1,y1)))))*(y1-y0));
    dz[xi][yi] += impulse;
    dz[xi+1][yi] += impulse;
    dz[xi][yi+1] += impulse;
    dz[xi+1][yi+1] += impulse;
  }
}

public void surfnorm(int x, int y, float nx, float ny) {
  float z0 = z[x%gwidth][y%gheight]*(50/zs)+pow(noise(nx,ny,zoff),power);
  float z1 = z[x%gwidth][(y+1)%gheight]*(50/zs)+pow(noise(nx,ny+ns,zoff),power);
  float z2 = z[(x+1)%gwidth][y%gheight]*(50/zs)+pow(noise(nx+ns,ny,zoff),power);
  float z3 = z[x%gwidth][abs(y-1)%gheight]*(50/zs)+pow(noise(nx,ny-ns,zoff),power);
  float z4 = z[abs(x-1)%gwidth][y%gheight]*(50/zs)+pow(noise(nx-ns,ny,zoff),power);
  v1.set(0, gridSize, (z1-z0)*zs);
  v2.set(gridSize, 0, (z2-z0)*zs);
  v3.set(0, -gridSize, (z3-z0)*zs);
  v4.set(-gridSize, 0, (z4-z0)*zs);
  v5 = PVector.add(PVector.add(v1.cross(v2),v2.cross(v3)),PVector.add(v3.cross(v4),v4.cross(v1)));
  v5.normalize();
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#EBE9ED", "fish_pond6v3" });
  }
}
