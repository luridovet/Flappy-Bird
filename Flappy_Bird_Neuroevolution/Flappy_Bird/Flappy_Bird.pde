
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
    saveBrain();
  }
  if (key == 'l') {
    loadBrain();
  }
  if (key == 'd') {
    savedBirds.add(birds.get(0));
    birds.remove(0);
  }
}

void saveBrain() {
  Bird b = birds.get(0);
  String[] brain = new String[4];

  String Wih = "";//"Wih/";
  for (int i = 0; i < b.brain.weights_ih.rows; i++) {
    for (int j = 0; j < b.brain.weights_ih.cols; j++) {
      //println(b.brain.bias_h.matrix[i][0]);
      Wih = Wih + str(b.brain.weights_ih.matrix[i][j]);
      if (j != b.brain.weights_ih.cols-1) {
        Wih = Wih + ",";
      }
    }
    if (i != b.brain.weights_ih.rows-1) {
      Wih = Wih + "|";
    }
  }
  brain[0] = Wih;

  String Woh = "";//"Woh/";
  for (int i = 0; i < b.brain.weights_ho.rows; i++) {
    for (int j = 0; j < b.brain.weights_ho.cols; j++) {
      //println(b.brain.bias_h.matrix[i][0]);
      Woh = Woh + str(b.brain.weights_ho.matrix[i][j]);
      if (j != b.brain.weights_ho.cols-1) {
        Woh = Woh + ",";
      }
    }
    if (i != b.brain.weights_ho.rows-1) {
      Woh = Woh + "|";
    }
  }
  brain[1] = Woh;

  String Bh = "";//"Bh/";
  for (int i = 0; i < b.brain.bias_h.rows; i++) {//Float f : b.brain.bias_h) {
    //println(b.brain.bias_h.matrix[i][0]);
    Bh = Bh + str(b.brain.bias_h.matrix[i][0]);
    if (i != b.brain.bias_h.rows-1) {
      Bh = Bh + ",";
    }
  }
  brain[2] = Bh;

  String Bo = "";//"Bo/";
  for (int i = 0; i < b.brain.bias_o.rows; i++) {//Float f : b.brain.bias_h) {
    //println(b.brain.bias_h.matrix[i][0]);
    Bo = Bo + str(b.brain.bias_o.matrix[i][0]);
    if (i != b.brain.bias_o.rows-1) {
      Bo = Bo + ",";
    }
  }
  brain[3] = Bo;  

  saveStrings("good_weights.txt", brain);
}

void loadBrain() {
  String[] brain = loadStrings("good_weights.txt");

  Matrix Wih = fromString(brain[0]);
  Matrix Who = fromString(brain[1]);
  Matrix Bh = fromString(brain[2]);
  Matrix Bo = fromString(brain[3]);

  Bh = Bh.Transpose();
  Bo = Bo.Transpose();

  birds.get(0).brain.weights_ih = Wih;
  birds.get(0).brain.weights_ho = Who;
  birds.get(0).brain.bias_h = Bh;
  birds.get(0).brain.bias_o = Bo;

  //Bh = Bh.Transpose();
  //Bo = Bo.Transpose();

  //Wih.Print();
  //Who.Print();
  //Bh.Print();
  //Bo.Print();

  //println();

  //birds.get(0).brain.weights_ih.Print();
  //birds.get(0).brain.weights_ho.Print();
  //birds.get(0).brain.bias_h.Print();
  //birds.get(0).brain.bias_o.Print();


  //birds.get(0).brain.weights_ih.Print();
}
