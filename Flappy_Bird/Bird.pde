class Bird {

  PVector pos;
  PVector vel;
  PVector acc;
  float initY = height/2;
  float r = 6;

  float score;
  float fitness;

  NeuralNetwork brain;

  Bird(NeuralNetwork brein) {
    this.pos = new PVector(200, initY);
    this.vel = new PVector(0, 0);
    this.acc = new PVector();

    if (brein != null) {
      this.brain = brein.Copy();
    } else {
      this.brain = new NeuralNetwork(5, 8, 2);
    } 
    this.score = 0;
    this.fitness = 0;
  }


  
  void mutate() {
    this.brain.Mutate(0.1);
  }


  void think(ArrayList<Pipe> p) {

    //Find closest pipe
    Pipe closest = p.get(0);
    float closestD = 100000;
    for (int i = 0; i < p.size(); i++) {
      float d = (p.get(i).x + p.get(i).w) - this.pos.x;
      if (d < closestD && d > 0) {
        closest = p.get(i);  
        closestD = 0;
      }
    }
    
    closest.c = color(255,0,0);
    
    float[] inputs = new float[5];
    inputs[0] = this.pos.y/height;
    inputs[1] = (closest.h + closest.space/2)/height;//closest.h/height;
    inputs[2] = 0;//(closest.h + closest.space)/height;  //3:52 P4
    inputs[3] = (closest.x)/width;
    inputs[4] = this.vel.y / 10;

    float[] output = this.brain.feedforward(inputs);
    if (output[0] > output[1] &&  this.vel.y >= 0) {
      this.jump();
    }
  }


  void show() {
    stroke(255);
    fill(255, 50);
    ellipse(this.pos.x, this.pos.y, pow(r, 2), pow(r, 2));
  } 


  void applyForce(PVector force) {
    this.acc.add(force);
  }

  void jump() {
    PVector up = new PVector(0, -14);
    this.applyForce(up);
  }
  
  
  void update() {
    this.score++;

    applyForce(gravity);
    this.vel.add(acc);
    this.pos.add(vel);
    this.vel.limit(10);
    this.acc.mult(0);
    //if (this.pos.y > height) {
    //  this.pos.y = height;
    //  this.vel = new PVector(0, 0);
    //}

    //if (this.pos.y < 0) {
    //  this.pos.y = 0;
    //  this.vel = new PVector(0, 0);
    //}
  }
}
