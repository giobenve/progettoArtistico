//Nicholas Tang
//3/25/11
int t, numfish, cnum, cnum2, sp10 = 35, period, gwidth, gheight;
ArrayList fishes, foods;
PImage scaleTemplate;
PImage caustics[];
PGraphics pg, fishskin;
PGraphics[] causticss;
PVector v1,v2,v3,v4,v5;
color[] palette = new color[5], palette2 = new color[5];
float increment = 0.075, zrand, invprec;
boolean leavechasing;
float[] sinTable, cosTable;
float[][] z, dz;

void setup() {
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
  period = int(360*invprec);
  sinTable = new float[period*2];
  cosTable = new float[period*2];
  for (int i = 0; i < period*2; i ++) {
    sinTable[i] = sin(radians(i/invprec));
    cosTable[i] = cos(radians(i/invprec));
  }
  scaleTemplate = loadImage("fishscale.png");
  colorMode(HSB,360);
  palette[0] = color(0,360,0.05*360); // black
  palette[1] = color(250, .03*360, 360); //white
  palette[2] = color(352, 360, 0.75*360); //red
  palette[3] = color(48, .97*360, 0.98*360); //yellow
  palette[4] = color(29,0.96*360,0.94*360); //orange
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
    fishes.add(new fish((-width/2)-random(width*1.5),-(height/2)+(floor(random(numfish))*(height/numfish)),(3*PI)/2,cnum2,fishskin));
  }
  caustics = new PImage[30];
  causticss = new PGraphics[30];
  for (int i = 0; i < 30; i ++) {
    caustics[i] = loadImage("caustics_" + nf(i+1,3) + ".bmp");
    caustics[i].resize(450,500);
    causticss[i] = seam(caustics[i],i);
  }
}

void draw() {
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

float sign(float a) {
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

PGraphics skin() {
  color c1, c2, c1n, c2n;
  cnum = floor(random(4.99));
  cnum2 = floor(random(3.99)+1);
  if ((cnum2 > 1) && (cnum > 1)) {
    if (boolean(round(random(1)))) {
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
  PGraphics scales = createGraphics(98+31-15, int(0.2*((60/8)*3)/.4*2)+1,P2D);
  noiseDetail(2,1.5);
  scales.loadPixels();
  float yoff = 0.0;
  for (int y = 0; y < scales.height; y++) {
    yoff += increment;
    float xoff = 0.0;
    float b2lim = 0.6;
    if (cnum != 0) {
      c1 = color(hue(c1n),saturation(c1n),sqrt(pow(scales.height/2,2)-pow((y-scales.height/2),2))*((360*2)/scales.height));
    } 
    else {
      c1 = c1n;
    }
    c2 = color(hue(c2n),saturation(c2n),sqrt(pow(scales.height/2,2)-pow((y-scales.height/2),2))*((360*2)/scales.height));
    for (int x = 0; x < scales.width; x++) {
      xoff += increment;
      int bright = int(noise(xoff,yoff,zrand) > 0.6);
      int bright2 = int(noise(xoff,yoff,zrand) > b2lim);
      if (x<98-15-8) {
        scales.pixels[x+y*scales.width] = c1*int(bright==1) + c2*int(bright==0);
        //scales.pixels[x+y*scales.width] = c1;
      } 
      else {
        scales.pixels[x+y*scales.width] = c1*int(bright2==1) + c2*int(bright2==0);
        //scales.pixels[x+y*scales.width] = c2;
        b2lim += 0.014;
      }
    }
  }
  zrand +=PI;
  scales.mask(scaleTemplate);
  return scales;
}

void detectfood(fish fish1, int i) {
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

float sinLUT(float rad) {
  return sinTable[(int(degrees(rad)*invprec) % period) + period];
}

float cosLUT(float rad) {
  return cosTable[(int(degrees(rad)*invprec) % period) + period];
}

PGraphics seam(PImage inp, int i) {
  PGraphics ret = createGraphics(width, height, P2D);
  ret.beginDraw();
  //-inp.width+int(i*(inp.width*1./60))
  for(int j=0; j<=width; j+=inp.width) {
    ret.copy(inp,0,0,inp.width,inp.height,j,0,inp.width,inp.height);
  }
  ret.endDraw();
  return ret;
}


