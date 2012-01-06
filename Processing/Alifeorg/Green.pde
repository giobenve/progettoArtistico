class Green extends Organism {

  Green(int x, int y) { 

    super(x, y, "green.svg");
    gene1 = (int) random(100, 255);
    gene2 = (int) random(50, 500);
    gene0 = color(gene1, gene2, random(255));
  }

  void mangia(FBody f) {

    /*if (f instanceof Food && good((Food) f)) {
      m_world.remove(f);

      if (f == target) {
        target = null;
      }

      recreate(1.1);
      dimagrimentoTimer = millis();
    } 
    else*/ if (f instanceof Organism && good((Organism) f)) {
      m_world.remove(f);

      if (f == target) {
        target = null;
      }

      recreate(1.5);
      dimagrimentoTimer = millis();
    }

    //Figli
    if (outline.getHeight() > 80) {
      Organism org = new Green((int)getX(), (int)getY());
      org.gene0 = gene0;
      org.gene1 = gene1;
      org.gene2 = gene2;
      m_world.add(org);
      recreate(0.25);
      return;
    }
  }

  public boolean good(Organism f) {
    if (f instanceof Green || f.outline.getHeight() >= outline.getHeight()) { 
      return false;
    }

    return dist(red(f.gene0), green(f.gene0), blue(f.gene0), red(gene0), green(gene0), blue(gene0)) < gene1;
  }

}

