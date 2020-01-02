class Food {
  PVector pos;
  float value;
  float maxValue;
  Food(PVector pos, float value) {
    this.pos = pos;
    this.value = value;
    maxValue = value;
  }
  
  Food(float value) {
    this(new PVector(random(0, width), random(0, height)), value);
  }
  
  void eat() {
    value = 0;
  }
  
  void reset() {
    pos.x = random(0, width);
    pos.y = random(0, height);
    value = maxValue;
  }
  
  void draw() {
    if (value == 0)
      return;
    ellipseMode(CENTER);
    fill(0,255,0);
    noStroke();
    ellipse(pos.x, pos.y, 10, 10);
  }
}
