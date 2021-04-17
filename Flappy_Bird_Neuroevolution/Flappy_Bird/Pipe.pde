class Pipe {
  float x;
  float w = 40;
  float h;
  float speed = 15;
  float space;
  color c;



  Pipe() {
    this.x = width + w - 100;
    this.h = random(0, height/2);
    this.space = 70;//random(300,225);
  }

  boolean hit(Bird b) {
    if (b.pos.x + b.r > this.x && b.pos.x - b.r < (this.x+w)) {
      if (b.pos.y + b.r < this.h || b.pos.y-b.r> this.h + space) {
        return true;
      }
    }
    return false;    
  }

  void show() {
    fill(c);    
    rect(x, 0, w, h);
    rect(this.x, this.h + space, this.w, height);
  }

  void move(float increment) {
    this.x -= increment;
  }
}
