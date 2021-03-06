class Pink extends Organism {

  Pink(int x, int y) { 
    super(x, y, "pink.svg");
    gene1 = (int) random(50, 255);
    gene2 = (int) random(50, 400);
    //gene0 = color(255, 255, 255);
    gene0 = gui.cp.getColorValue();
  }

  void mangia(FBody f) {

    if (good((Food) f)) {
      m_world.remove(f);

      //Figli
      if (outline.getHeight() > 80) {
        Organism org = new Pink((int)getX(), (int)getY());
        org.gene0 = color(
          constrain(red(gene0) + (int)random(-10,+10), 0, 255),
          constrain(green(gene0) + (int)random(-10,+10), 0, 255),
          constrain(blue(gene0) + (int)random(-10,+10), 0, 255)
        );
        org.gene1 = gene1 + (int)random(-10,+10);
        org.gene2 = gene2 + (int)random(-10,+10);
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

