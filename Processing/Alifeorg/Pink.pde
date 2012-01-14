class Pink extends Organism {

  Pink(int x, int y) { 
    super(x, y, "pink.svg");

<<<<<<< HEAD
    gene1 = (int) random(50, 255);
    gene2 = (int) random(50, 400);
    gene0 = color(255, 255, 255);
=======
    gene1 = (int) random(100, 255);
    gene2 = (int) random(50, 400);
    gene0 = color(gene1, gene2, random(255));
>>>>>>> 9a732a37fa2b76cdf6d14b76d5266ccd4d313f56
  }

  void mangia(FBody f) {

    if (good((Food) f)) {
      m_world.remove(f);

      //Figli
      if (outline.getHeight() > 80) {
        Organism org = new Pink((int)getX(), (int)getY());
        org.gene0 = gene0;
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

}

