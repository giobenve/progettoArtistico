class Orange extends Organism {
  
  Orange(int x, int y) { 
    super(x,y,"orange.svg");
    gene1 = (int) random(900);
    gene2 = (int) random(50,900);
    //gene0 = color(0, 255, 0);
    gene0 = gui.cp.getColorValue();
  }
  
  void mangia(FBody f) {
    
    if (good((Food) f)) {
      m_world.remove(f);
    //Figli
    if (outline.getHeight() > 80) {
      Organism org = new Orange((int)getX(), (int)getY());
      org.gene0 = color(
        constrain(red(gene1) + (int)random(-10,+10), 0, 255),
        constrain(green(gene1) + (int)random(-10,+10), 0, 255),
        constrain(blue(gene1) + (int)random(-10,+10), 0, 255)
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


