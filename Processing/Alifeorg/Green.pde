class Green extends Organism {
  

  
    Green(int x, int y, color c) {
    super(x,y,c, "green.svg");  
  }
  
  void mangia(Food f) {
    //Figli
    if (outline.getHeight() > 80) {
      Organism org = new Green((int)getX(), (int)getY(), gene0);
      org.gene1 = gene1;
      org.gene2 = gene2;
      m_world.add(org);
      recreate(0.25);
      return;
    }

    if (f == target) {
      target = null;
    }

    recreate(1.1);
    dimagrimentoTimer = millis();
  }
}
