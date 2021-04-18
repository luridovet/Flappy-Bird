class Bird {


  PVector pos;
  PVector vel;
  PVector acc;
  float y;
  float initY = height/2;
  float r = 6;


  Bird() {
    pos = new PVector(100, initY);
    vel = new PVector(0, 0);
    vel = vel.limit(4);
    acc = new PVector();
  }


  void show() {
    fill(0, 0, 255);
    ellipse(pos.x, pos.y, pow(r,2),pow(r,2));
  } 


  void applyForce(PVector force) {
    acc.add(force);
  }

  void update() {
    applyForce(gravity);
    vel.add(acc);
    pos.add(vel);
    vel.limit(10);
    acc.mult(0);
  }


}
