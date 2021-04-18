void nextGeneration() {
  caclulateFitness();
  for (int i = 0; i < pop; i++) {
    birds.add(pickOne());
  }
  savedBirds.clear();
}

Bird pickOne() {
  int index = 0;
  float r = random(1);
  
  while (r > 0) {
    r -= savedBirds.get(index).fitness;
    index++;
  }
  index--;

  Bird bird = savedBirds.get(index);  //savedBirds.get(int(random(savedBirds.size())));
  Bird child = new Bird(bird.brain);
  child.brain.Mutate(0.1);
  return child;
}

void caclulateFitness() {
  int totScore = 0;
  for (Bird b : savedBirds) {
   b.score = pow(b.score,2);
  }
  for (Bird b : savedBirds) {
    totScore += b.score;
  }
  for (Bird b : savedBirds) {
    b.fitness = b.score/totScore;
  }
}
