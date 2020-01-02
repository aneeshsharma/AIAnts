ArrayList<Ant> ants;
ArrayList<Food> food;

ArrayList<Float> progress;

boolean isAlive;

float mutationProb = 0.2;

int generation;

float bestScore, lastBest;
void setup() {
  fullScreen(P2D);
  ants = new ArrayList<Ant>();
  food = new ArrayList<Food>();
  for (int i = 0; i < 50; i++)
    ants.add(new Ant(0.1));
  
  progress = new ArrayList<Float>();
    
  for (int i = 0; i < 500; i++)
    food.add(new Food(5));
  isAlive = true;
}

void draw() {
  background(0);
  
  for (Ant ant : ants)
    ant.draw();
    
  for(Food f : food)
    f.draw();
  /*  
  stroke(255);
  fill(0, 50, 50);
  rect(-1, -1, 200, 120);
  fill(255);
  textSize(20);
  bestScore = getBest(ants).survival;
  text("Best : " + bestScore + "\nGeneration " + generation + "\nLast : " + lastBest, 10, 30);
  
  
  for(int i = 0; i < progress.size(); i++) {
    stroke(0, 0, 255, 125);
    strokeWeight(3);
    line(i * 3, height - progress.get(i), i * 3, height);
    strokeWeight(1);
  }*/
  
  for (int i = 0; i < 1; i++)
    step();
}

void step() {
  isAlive = false;
  for (Ant ant : ants) {
    ant.step(food);
    if (ant.isAlive) isAlive = true;
  }
  
  if (!isAlive) {
    lastBest = bestScore;
    println("Generation Complete | Best : " + bestScore);
    Ant best = getBest(ants);
    Ant second = getSecondBest(ants, best);
    
    progress.add(bestScore);
    
    ArrayList<Float> bestGenes = best.getGenes();
    ArrayList<Float> secondGenes = second.getGenes();
    
    for (Ant ant : ants) {
      int crossPoint = (int) random(bestGenes.size());
      ArrayList<Float> newGenes = cross(bestGenes, secondGenes, crossPoint);
      newGenes = mutate(newGenes, 10);
      ant.setGenes(newGenes);
      ant.Resurrect();
    }
    
    for (Food f : food)
      f.reset();
     generation++;
  }
}

Ant getBest(ArrayList<Ant> ants){
  float maxSurvival = 0;
  Ant best = ants.get(0);
  for (Ant ant : ants) {
    if (ant.survival > maxSurvival) {
      maxSurvival = ant.survival;
      best = ant;
    }
  }
  return best;
}

Ant getSecondBest(ArrayList<Ant> ants, Ant best){
  float maxSurvival = 0;
  Ant second = ants.get(0);
  for (Ant ant : ants) {
    if (ant.survival > maxSurvival && ant.survival <= best.survival) {
      maxSurvival = ant.survival;
      second = ant;
    }
  }
  return second;
}

ArrayList<Float> cross(ArrayList<Float> a, ArrayList<Float> b, int crossPoint) {
  ArrayList<Float> cross = new ArrayList<Float>();
  int i = 0;
  for (i = 0; i < a.size(); i++) {
    if (i < crossPoint){
      cross.add(a.get(i));
    } else {
      cross.add(b.get(i));
    }
  }
  
  return cross;
}

ArrayList<Float> mutate(ArrayList<Float> genes, float delta) {
  for (int i = 0; i < genes.size(); i++) {
    float chance = random(0, 1);
    if (chance < mutationProb) {
      genes.set(i, genes.get(i) + random(-1, 1) * delta);
    }
  }
  
  return genes;
}
