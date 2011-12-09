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
