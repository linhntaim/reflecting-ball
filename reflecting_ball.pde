/**
 *    Balls are falling to ground by gravity. You can click/tap on screen to make the nearest ball jump.
 *    The collision between two of any balls is calculated based on the solution described in <a title="Euclidean Space - The article of Physics - Collision in 2 dimensions" href="http://www.euclideanspace.com/physics/dynamics/collision/twod/">this article</a>.
 */

class Ball {
  color colour;
  float radius;
  float mass;
  PVector location;
  PVector velocity;
  PVector acceleration;
  TableSurface table;

  Ball() {
    colour=color(int(round(random(0, 255))), int(round(random(0, 255))), int(round(random(0, 255))));
    radius=random(8, 64);
    mass=pow(radius, 2)*PI;
    location=new PVector(random(radius, width-radius), random(radius, height/2));
    velocity=new PVector(5*(random(0, 1)<0.5?1:-1), 0);
    acceleration=new PVector(0, 0.375);
    //    move all ball on the ground
    //    location=new PVector(random(radius, width-radius), height-radius);
    //    velocity=new PVector(5, 0);
    //    acceleration=new PVector(0, 0);
    table=new TableSurface();
  }

  void collideTableSurface() {
    velocity=new PVector(6.137*(velocity.x/abs(velocity.x)), -10.63);
    table.display(location.x, location.y, radius, 20);
  }

  boolean checkBallCollision(Ball ball) {
    PVector l = PVector.sub(ball.location, location);
    float d=l.mag();
    float dMax=radius+ball.radius;

    if (d <= dMax) {
      PVector lTemp=new PVector(l.x, l.y);
      lTemp.setMag((dMax-d)/2);
      lTemp.add(location);
      location.x=lTemp.x;
      location.y=lTemp.y;
      lTemp=new PVector(l.x, l.y);
      lTemp.mult(-1);
      lTemp.setMag((dMax+d)/2);
      lTemp.add(location);
      ball.location.x=lTemp.x;
      ball.location.y=lTemp.y;

      return true;
    }

    return false;
  }

  void collideBall(Ball ball) {
    PVector l = PVector.sub(ball.location, location);
    float d=l.mag();
    float dMax=radius+ball.radius;

    if (d <= dMax) {
      PVector lTemp=new PVector(l.x, l.y);
      lTemp.setMag((dMax-d)/2);
      lTemp.add(location);
      location.x=lTemp.x;
      location.y=lTemp.y;
      lTemp=new PVector(l.x, l.y);
      lTemp.mult(-1);
      lTemp.setMag((dMax+d)/2);
      lTemp.add(location);
      ball.location.x=lTemp.x;
      ball.location.y=lTemp.y;

      float theta  = atan2(l.y, l.x);
      float sine = sin(theta);
      float cosine = cos(theta);

      PVector l1i=new PVector(0, 0);
      PVector l2i=new PVector(cosine * l.x + sine * l.y, cosine * l.y - sine * l.x);
      PVector v1i=new PVector(cosine*velocity.x+sine*velocity.y, cosine*velocity.y-sine*velocity.x);
      PVector v2i=new PVector(cosine*ball.velocity.x+sine*ball.velocity.y, cosine*ball.velocity.y-sine*ball.velocity.x);

      PVector v1f=new PVector(((mass - ball.mass) * v1i.x + 2 * ball.mass * v2i.x) / (mass + ball.mass), v1i.y);
      PVector v2f=new PVector(((ball.mass - mass) * v2i.x + 2 * mass * v1i.x) / (mass + ball.mass), v2i.y);
      l1i.x += v1f.x;
      l2i.x += v2f.x;

      PVector l1f=new PVector(cosine * l1i.x - sine * l1i.y, cosine * l1i.y + sine * l1i.x);
      PVector l2f=new PVector(cosine * l2i.x - sine * l2i.y, cosine * l2i.y + sine * l2i.x);

      ball.location.x = location.x + l2f.x;
      ball.location.y = location.y + l2f.y;
      location.x = location.x + l1f.x;
      location.y = location.y + l1f.y;

      ball.velocity.x = cosine * v2f.x - sine * v2f.y;
      ball.velocity.y = cosine * v2f.y + sine * v2f.x;
      velocity.x = cosine * v1f.x - sine * v1f.y;
      velocity.y = cosine * v1f.y + sine * v1f.x;

      while (PVector.sub (ball.location, location).mag()<dMax) {
        update();
      }
    }
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(MAX_VELOCITY);
    location.add(velocity);
  }

  void display() {
    noStroke();
    fill(colour);
    ellipse(location.x, location.y, radius*2, radius*2);
  }

  void checkEdges() {
    if (location.x>width-radius) {
      location.x=width-radius;
      velocity.x*=-1;
    } else if (location.x<radius) {
      location.x=radius;
      velocity.x*=-1;
    }
    if (location.y>height-radius) {
      location.y=height-radius;
      velocity.y*=-1;
    } else if (location.y<radius) {
      location.y=radius;
      velocity.y*=-1;
    }
  }
}

class TableSurface {
  void display(float x, float y, float radius, float bonus) {
    stroke(0);
    strokeWeight(4);
    line(x-radius-bonus, y+radius, x+radius+bonus, y+radius);
  }
}

class Label {
  float x;
  float y;
  float tS;
  float tW;
  String t;

  Label(float x_, float y_, float textSize_, String text_) {
    x=x_;
    y=y_;
    t=text_;
    tS=textSize_;
    textSize(tS);
    tW=textWidth(text_);
  }

  void display() {
    fill(0);
    textSize(tS);
    text(t, x, y+tS/2);
  }
}

class Button {
  float x;
  float y;
  float rW;
  float rH;
  float tS;
  float tW;
  String t;

  Button(float x_, float y_, String text_) {
    x=x_;
    y=y_;
    t=text_;
    tS=14;
    textSize(tS);
    tW=textWidth(text_);
    rW=100;
    rH=40;
  }

  void display() {
    stroke(0);
    strokeWeight(1);
    fill(175);
    rect(x-rW/2, y-rH/2, rW, rH);
    fill(0);
    textSize(tS);
    text(t, x-tW/2, y+tS/2);
  }

  boolean isClicked() {
    return mouseX>=x-rW/2&&mouseX<=x+rW/2 &&
      mouseY>=y-rH/2&&mouseY<=y+rH/2;
  }
}

int NUM_OF_BALLS;
float MAX_VELOCITY;
Ball[] BALLS;
Button RESET;

void setup() {
  size(800, 640);
  background(255);
  smooth();

  MAX_VELOCITY=sqrt(pow(width, 2)+pow(height, 2))/2;
  RESET=new Button(740, 30, "RANDOMIZE");

  reset();
}

void draw() {
  background(255);

  RESET.display();
  STATUS.display();

  for (int i=0; i<NUM_OF_BALLS; ++i) {
    BALLS[i].update();
    BALLS[i].checkEdges();
  }

  for (int i=0; i<NUM_OF_BALLS-1; ++i) {
    for (int j=i+1; j<NUM_OF_BALLS; ++j) {
      BALLS[i].collideBall(BALLS[j]);
    }
  }

  for (int i=0; i<NUM_OF_BALLS; ++i) {
    BALLS[i].display();
  }
}

void reset() {
  NUM_OF_BALLS=int(round(random(3, 6)));
  STATUS=new Label(20, 20, 14, "Number of Balls: "+NUM_OF_BALLS);
  BALLS=new Ball[NUM_OF_BALLS];
  for (int i=0; i<NUM_OF_BALLS; ++i) {
    BALLS[i]=new Ball();
  }

  for (int i=0; i<NUM_OF_BALLS-1; ++i) {
    for (int j=i+1; j<NUM_OF_BALLS; ++j) {
      BALLS[i].checkBallCollision(BALLS[j]);
    }
  }
}

void mousePressed() {
  if (RESET.isClicked()) {
    reset();
  } else {
    int iMin=0;
    float dMin=abs(PVector.sub(BALLS[0].location, new PVector(mouseX, mouseY)).mag()-BALLS[0].radius);
    for (int i=1; i<NUM_OF_BALLS; ++i) {
      float d=abs(PVector.sub(BALLS[i].location, new PVector(mouseX, mouseY)).mag()-BALLS[i].radius);
      if (d<dMin) {
        iMin=i;
        dMin=d;
      }
    }

    BALLS[iMin].collideTableSurface();
  }
}


