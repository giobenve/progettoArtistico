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

