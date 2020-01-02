class NeuralNet {
  ArrayList<float[]> layers;
  ArrayList<float[][]> weights;
  int numLayers;
  int[] numNeurons;
  NeuralNet(int[] neurons){
    numLayers = neurons.length;
    numNeurons = neurons;
    layers = new ArrayList<float[]>();
    for (int i = 0; i<numLayers; i++) {
      if (i == numLayers - 1) {
         layers.add(new float[neurons[i]]);
          continue;
      }
      layers.add(new float[neurons[i] + 1]);
      layers.get(i)[neurons[i]] = -1; // Bias
    }
    
    weights = new ArrayList<float[][]>();
    for (int i = 0; i < numLayers - 1; i++) {
      weights.add(new float[layers.get(i).length][layers.get(i + 1).length]);
    }
  }
  
  float sigmoid(float x) {
    return 1 / (1 + exp(-x));
  }
  
  void forward() {
    for (int i=0; i < layers.size() - 1; i++) {
      for (int j = 0; j < ((i == layers.size() - 2) ? layers.get(i + 1).length : layers.get(i + 1).length - 1); j++){
        float[] ins = new float[layers.get(i).length];
        for (int k = 0; k < ins.length; k++) {
          ins[k] = weights.get(i)[k][j] * layers.get(i)[k];
        }
        
        layers.get(i + 1)[j] = sigmoid(sum(ins));
      }
    }
  }
  
  void randomize(float range) {
    for(float[][] q : weights) {
      for (float[] x : q) {
        for (int i = 0; i < x.length; i++){
          x[i] = random(-range, range);
        }
      }
    }
  }
  
  ArrayList<Float> getGenes() {
    ArrayList<Float> genes = new ArrayList<Float>();
    for(float[][] q : weights) {
      for (float[] x : q) {
        for (int i = 0; i < x.length; i++){
          genes.add(x[i]);
        }
      }
    }
    
    return genes;
  }
  
  void setGenes(ArrayList<Float> genes) {
    int geneI = 0;
    for(float[][] q : weights) {
      for (float[] x : q) {
        for (int i = 0; i < x.length; i++){
          x[i] = genes.get(geneI);
          geneI++;
        }
      }
    }
  }
  
  void setInputs(float[] input) {
    if (input.length != layers.get(0).length - 1)
      return;
    for (int i = 0; i < input.length; i++)
      layers.get(0)[i] = input[i];
  }
  
  float[] output() {
    int outLayer = layers.size() - 1;
    float[] out = new float[layers.get(outLayer).length];
    for (int i=0; i < out.length; i++) {
      out[i] = layers.get(outLayer)[i];
    }
    return out;
  }
  
  float sum(float[] elements) {
    float sum = 0;
    for (float x : elements)
      sum += x;
    return sum;
  }
}
