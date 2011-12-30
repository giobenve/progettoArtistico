class Orange extends Organism {
  
  Orange(int x, int y, color c) { 
    super(x,y,c, "orange.svg");
    gene1 = (int) random(40,70);
    gene2 = (int) random(200,700);

  }
  
  void mangia(FBody f) {
    
    if (good((Food) f)) {
      m_world.remove(f);
    //Figli
    if (outline.getHeight() > 80) {
      Organism org = new Orange((int)getX(), (int)getY(), gene0);
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
  
    public boolean good(Food f) {
    return dist(red(f.gene0), green(f.gene0), blue(f.gene0), red(gene0), green(gene0), blue(gene0)) < 50;
  }
  
}

