
Bird b;

int pop = 500; 
ArrayList<Pipe> pipes = new ArrayList<Pipe>();
ArrayList<Bird> birds = new ArrayList<Bird>();

ArrayList<Bird> savedBirds = new ArrayList<Bird>();

PVector gravity = new PVector(0, 0.7);
boolean alive = true;

int counter = 0;
int cycles = 1;
int gen = 1;

int highscore;
int gen_score;

void setup() {
  //size(1000, 800);
  //pipes.add(new Pipe());

  for (int i = 0; i < pop; i++) {
    birds.add(new Bird(null));
  }
  
}

public void settings() {
  size(1000, 800);
  
}


void draw() {

  for (int n = 0; n < cycles; n++) {
    if (counter % 75 == 0 && alive) {
      pipes.add(new Pipe()) ;
    }

    counter++;

    for (int i = 0; i<pipes.size(); i++) {     
      Pipe p = pipes.get(i);
      p.c = color(0, 255, 0);


      p.move(5);

      for (int j = birds.size()-1; j >= 0; j--) {
        if (p.hit(birds.get(j)) == true) { // ||  birds.get(j).pos.y - 10 < 0) {
          savedBirds.add(birds.get(j));
          birds.remove(j);
        }
      }

      if (p.x < -p.w) {
        pipes.remove(i);
      }
      if (p.x == 100) {
        gen_score ++;
      }
    }

    for (int i = birds.size()-1; i >= 0; i--) {
      if ( birds.get(i).pos.y > height  ||  birds.get(i).pos.y < 0   ||  birds.get(i).pos.y > height) {
        savedBirds.add(birds.get(i));
        birds.remove(i);
      }
    }

    for (Bird b : birds) {
      b.update();
      b.think(pipes);
    }

    if (birds.size() == 0 ) {
      counter = 0;
      gen++;
      nextGeneration();
      //println("Generation : " + str(gen));
      pipes.clear();
      gen_score = 0;
    }
  }



  //Drawing stuff
  background(10);

  for (Bird b : birds) {
    b.show();
  }

  for (Pipe p : pipes) {
    p.show();
  }
  fill(255);
  textSize(40);
  text("gen : " + gen, 10, 50);
  text("birds alive : " + birds.size(), 10, 100);
  text("score : " + gen_score, 10, 150);
}

void keyPressed() {
  if (key == '1') {
    cycles = 1;
  }
  if (key == '2') {
    cycles = 2;
  }
  if (key == '3') {
    cycles = 10;
  }
  if (key == '4') {
    cycles = 100;
  }


  if (key == 's') {
    Bird b = birds.get(0);
    //JSONObject json = ;
    //saveJSONObject(b.brain, "bird.json");
    b.brain.weights_ih.Print();
  }
  if (key == 'd') {
    savedBirds.add(birds.get(0));
    birds.remove(0);
  }
}
