class GUI implements ControlListener {

  ControlP5 controlP5;

  ControlGroup panel;

  Button b;

  ColorPicker cp;

  int orgid = 1;

  GUI(ControlP5 cp5) {

    this.controlP5 = cp5;
    controlP5.addListener(this);

    b = controlP5.addButton("Opzioni (o)", 1, 20, 20, 100, 20);
    b.setId(99);   

    createPanel();
  }

  public void controlEvent(ControlEvent theEvent) {
    
    if(theEvent.isGroup()) {
      if (theEvent.group().name().equals("radioButton")) {
        orgid = (int)theEvent.group().value();
      } 
    } else if (panel.isVisible()) {
      panel.hide();
      //loop();
    } else {
      panel.show();
      //noLoop();
    }
    
    
    //Controller c = theEvent.controller();
    //println(c.name()+" "+c.id());

  }

  void createPanel() {
    panel = controlP5.addGroup("panel", width/2 - 150, 100, 300);
    panel.setBackgroundHeight(120);
    panel.setBackgroundColor(color(0, 100));
    panel.hideBar();

    cp = controlP5.addColorPicker("picker", 10, 10, 100, 20);//barra colori
    cp.moveTo(panel);

    RadioButton r = controlP5.addRadioButton("radioButton", 220, 10);
    r.addItem("pink", 0);
    r.addItem("orange", 1);
    r.addItem("green", 2);
    r.addItem("stone", 3);
    r.addItem("food", 4);
    r.moveTo(panel);
  }
}

