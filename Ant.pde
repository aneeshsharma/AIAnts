class Ant {
  PShape antShape;
  PVector pos;
  
  float heading, speed;
  
  NeuralNet net;
  float belly;
  float starveRate;
  
  float survival;

  boolean isAlive;
  
  Ant(float starve) {
    this(new PVector(random(0, width), random(0, height)), starve);
  }
  
  Ant(PVector pos, float starve) {
    this.pos = pos;
    antShape = createShape();
    antShape.beginShape();
    antShape.fill(255,0,0);
    antShape.stroke(255);
    antShape.vertex(-5, 0);
    antShape.vertex(0, -20);
    antShape.vertex(5, 0);
    antShape.vertex(-5, 0);
    antShape.endShape();
    
    belly = 100;
    starveRate = starve;
    isAlive = true;
    survival = 0;
    
    int[] neurons = {3, 5, 10, 4, 2};
    net = new NeuralNet(neurons);
    net.randomize(3);
  }
  
  void Resurrect(){
    belly = 100;
    isAlive = true;
    survival = 0;
    pos = new PVector(random(0, width), random(0, height));
  }
  
  ArrayList<Float> getGenes() {
    return net.getGenes();
  }
  
  void setGenes(ArrayList<Float> genes) {
    net.setGenes(genes);
  }
  
  void draw() {
    if (!isAlive)
      return;
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(heading + PI / 2);
    shape(antShape, 0, 0);
    popMatrix();
  }
  
  void step(ArrayList<Food> food) {
    if (!isAlive)
      return;
    belly -= starveRate;
    if (belly <= 0) {
      isAlive = false;
      return;
    }
    
    survival++;
    
    Food near = food.get(0);
    float minDis = PVector.dist(food.get(0).pos, pos);
    for (Food f : food) {
      float dis = PVector.dist(f.pos, pos);
      if (dis < 10) {
        // Eat
        belly += f.value;
        f.eat();
      }
      else if (minDis > dis){
        minDis = dis;
        near = f;
      }
    }
    
    stroke(255);
    float[] ins = {0, 0, 0};
    if (near != null) {
      ins[0] = (near.pos.x - pos.x) / width;
      ins[1] = (near.pos.y - pos.y) / height;
      ins[2] = near.value;
      line(near.pos.x, near.pos.y, pos.x, pos.y);
    }
    
    net.setInputs(ins);
    net.forward();
    
    float[] out = net.output();
    heading = out[0] * TWO_PI;
    speed = out[1] * 5;
    
    PVector v = new PVector(speed * cos(heading), speed * sin(heading));
    pos.add(v);
    checkBorder();
  }
  
  void checkBorder() {
    if (pos.y > height) pos.y = 0;
    else if (pos.y < 0) pos.y = height;
    if (pos.x > width) pos.x = 0;
    else if (pos.x < 0) pos.x = width;
  }
}
