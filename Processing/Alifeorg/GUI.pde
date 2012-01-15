class GUI implements ControlListener {

  ControlP5 controlP5;

  ControlGroup panel;
  
  Button b;

  ColorPicker cp;
  
  int orgid = 1;
  
  GUI(ControlP5 cp5) {

    this.controlP5 = cp5;
    controlP5.addListener(this);

    b = controlP5.addButton("Opzioni", 1, 20, 20, 100, 20);
    b.setId(99);   

    createPanel();
  }

  public void controlEvent(ControlEvent theEvent) {
    Controller c = theEvent.controller();
    println(c.name()+" "+c.id());
    switch(c.id()) {
      case(99):
      if (panel.isVisible()) {
        panel.hide();
      } 
      else {
        panel.show();
      }
      break;
      case(0):
      orgid = 0;
      break;
      case(1):
      orgid = 1;
      break;
      case(2):
      orgid = 2;
      break;
    }
  }

  void createPanel() {
    panel = controlP5.addGroup("panel", width/2 - 150, 100, 300);
    panel.setBackgroundHeight(120);
    panel.setBackgroundColor(color(0, 100));
    panel.hideBar();
    
    cp = controlP5.addColorPicker("picker", 10, 10, 100, 20);//barra colori
    cp.moveTo(panel);
    

    ControllerSprite sprite0 = new ControllerSprite(controlP5,loadImage("pink.png"),50, 50);
    controlP5.Button pink = controlP5.addButton("pink",2,0,70,50,50);
    pink.setSprite(sprite0);  

    pink.moveTo(panel);
    pink.setColorBackground(color(254, 155, 144));
    pink.setId(0);
    

    ControllerSprite sprite1 = new ControllerSprite(controlP5,loadImage("orange.png"),31, 31);
    controlP5.Button orange = controlP5.addButton("orange", 2, 51, 80, 31, 31);

    orange.setSprite(sprite1);  
    orange.moveTo(panel);
    orange.setColorBackground(color(254, 155, 144));
    orange.setId(1);
    

    ControllerSprite sprite2 = new ControllerSprite(controlP5,loadImage("green.png"),31, 31);
    controlP5.Button green = controlP5.addButton("green", 2, 92, 80, 31, 31);

    green.setSprite(sprite2);  
    green.moveTo(panel);
    green.setColorBackground(color(254, 155, 144));
    green.setId(2);
  }
}

