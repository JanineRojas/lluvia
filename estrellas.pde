class Particle {
  Body body;
  float r;
  PImage star;
  color col;
  int s1;
  boolean delete = false;

  Particle(float x, float y, float r_) {
    r = r_;
    s1=80;
    star = loadImage("dest.png");
    makeBody(x, y, r); //genera un nuevo cuerpo con estos parametros
    body.setUserData(this);
    col = color(255,255,0);
  }


  void killBody() {
    box2d.destroyBody(body);
  }

  void delete() {
    delete = true;
  }

  // Change color when hit
  void change() {
    col = color(255,0, 0);
    star=loadImage("bluestar.png");
  }
  
  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y > height+r*2 || delete) {
      killBody();
      return true;
    }
    return false;
  }

  void display() { //para dibujar las bolitas
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(col);
    noStroke();
   // ellipse(0, 0, r*2, r*2);
    popMatrix();
    image(star,pos.x-60,pos.y-60,s1,s1);
  }

  void makeBody(float x, float y, float r) {
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.01; //rebote

    body.createFixture(fd);
 
     body.setLinearVelocity(new Vec2(40, -75)); //diagonal

    body.setAngularVelocity(random(-10, 10)); //para que gire sobre su propio eje
  }
}