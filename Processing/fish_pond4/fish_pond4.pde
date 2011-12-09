//Nicholas Tang
//3/9/11
int t, numfish, sp = 35, cnum, cnum2;
ArrayList fishes, foods;
PImage scaleTemplate, a;
PGraphics pg, fishskin;
PVector v1,v2,v3,v4,v5;
color[] palette = new color[5];
color c1;

void setup(){
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
     palette[0] = color(250, .03*360, 360); //white
     palette[1] = color(48, .97*360, 0.98*360); //yellow
     palette[2] = color(29,0.96*360,0.94*360); //orange
     palette[3] = color(352, 360, 0.75*360); //red
     //palette[4] = color(0,360,0.05*360); // black
     size(900,500,P3D);
     pg = createGraphics(900, 500, P3D);
     numfish = 25;
     t = 0;
     foods = new ArrayList();
     fishes = new ArrayList();
     for (int i = 1; i < numfish+1; i++) {
       fishskin = skin();
       fishes.add(new fish((-width/2)/sp-random(width*1.5)/sp,-(height/2)/sp+(floor(random(numfish))*(height/numfish))/sp,(3*PI)/2,c1,fishskin));
     }
}

void draw(){
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
      fish1.nth = fish1.th+signs(random(-0.001,0.001))*random(PI/4);
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

float signs(float a){
  if (a > 0){
    return 1;
  } else if (a == 0){
    return 0;
  } else{
    return -1;
  }
}

PGraphics skin(){
  PGraphics scales;
  scales = createGraphics(98+31-15, int(0.2*((60/8)*3)/.4*2)+1,P2D);
  c1 = palette[floor(random(3.99))];
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

void detectfood(fish fish1, int i){
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
