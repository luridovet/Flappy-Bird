class Pipe {
  float x;
  float w = 75  ;
  float h;
  float speed = 5;
  float space = 200;
  color c;



  Pipe() {
    x = width + w - 100;
    h = random(100, height/2);
  }

  boolean hit(Bird b) {
    if (b.pos.x + b.r>x && b.pos.x - b.r < (x+w)) {
      if (b.pos.y+b.r < h || b.pos.y-b.r> h+200) {
        return true;
      }
    }
    return false;
  }

  void show() {
    fill(c);    
    rect(x, 0, w, h);
    rect(x, h + space, w, height);
  }

  void move() {
    x-=speed;
  }
}
