class GUI implements ControlListener {

  ControlP5 controlP5;

  ControlGroup panel;
  
  Button b;

  ColorPicker cp;

  GUI(ControlP5 cp5) {

    this.controlP5 = cp5;
    controlP5.addListener(this);

    b = controlP5.addButton("Opzioni", 1, 20, 20, 100, 20);
    b.setId(1);   

    createPanel();
  }

  public void controlEvent(ControlEvent theEvent) {
    Controller c = theEvent.controller();
    println(c.name()+" "+c.id());
    switch(c.id()) {
      case(1):
      if (panel.isVisible()) {
        panel.hide();
      } 
      else {
        panel.show();
      }
      break;
      case(2):

      break;
    }
  }

  void createPanel() {
    panel = controlP5.addGroup("panel", width/2 - 150, 100, 300);
    panel.setBackgroundHeight(120);
    panel.setBackgroundColor(color(0, 100));
    panel.hideBar();
    
    cp = controlP5.addColorPicker("picker", 10, 10, 100, 20);
    cp.moveTo(panel);
    
  }
}

