Bird b;

ArrayList<Pipe> pipes = new ArrayList<Pipe>();
PVector gravity = new PVector(0, 0.7);
float score;
boolean alive = true;

void setup() {
  size(500, 800);
  pipes.add(new Pipe());
  b = new Bird();
}

void draw() {
  background(10);

  b.show();
  b.update();



  if (frameCount % 75 == 0 && alive) {
    pipes.add(new Pipe()) ;
  }


  for (int i = 0; i<pipes.size(); i++) {     
    Pipe p = pipes.get(i);
    p.c = color(0, 255, 0);
    p.show();

    if (alive) {
      p.move();
    }


    if (p.hit(b) == true || b.pos.y > height) {
      b.vel = new PVector(0, 10);
      alive = false;
    } else { 
      score += 1;
    }

    if (p.x < -p.w) {
      pipes.remove(i);
    }
  }

  fill(255);
  textSize(50);
  text(int(score), width/2-25, 100);
}

void keyPressed() {
  if (alive) {
    PVector up = new PVector(0, -15 );
    b.applyForce(up);
  }
}
