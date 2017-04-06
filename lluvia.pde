import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

int aparecepantalla;
PGraphics letras;
PFont inicio;
float a;
float x;
float y;
float r;
float dx;
float dy;

Box2DProcessing box2d; //variable de tipo box2dprocessing

ArrayList<Particle> particles;

Boundary wall;

void setup() {
 size(1000, 500);
 frameRate(10);
 noStroke();
 background(0);
 inicio =  createFont("DancingScript-Regular.ttf",200);
   
   letras = createGraphics(1000,500);
  box2d = new Box2DProcessing(this); //clase extendida
  box2d.createWorld(); 
 
//colisión
  box2d.listenForCollisions();
  particles = new ArrayList<Particle>(); //inicializa la clase

  wall = new Boundary(width/2, height-5, width, 10); //el límite de abajo 
}

void draw() {
  switch(aparecepantalla){
  case 0:
  pinicio();
  
if(keyPressed){
  aparecepantalla++;
}
  break;
  case 1:
 background(0,0,51);

  if (random(1) < 0.05) { //velocidad
    float sz = random(2, 10);//tamaño
    particles.add(new Particle(random(height), 20, sz));
  }
  
  box2d.step(); //para que funcione toda la fisica

  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
    // Particles that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    if (p.done()) {
      particles.remove(i);
    }
  }

  wall.display(); //para dibujar el limite
}
}




 void pinicio(){
    fill(255);
  textFont(inicio);   
  text("City of Stars", 50, 290); 
  fill(0, 60);
rect(0, 0, width, height);

fill(230);
r = random(3, 8);
ellipseMode(CENTER);
x = random(r, width-r);
y = random(r, height-r);
ellipse(x + dx, y + dy, r, r);
a = a + 0.01;
 
 }

// colisión
void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Particle.class && o2.getClass() == Particle.class) {
    Particle p1 = (Particle) o1;
    p1.delete();
    Particle p2 = (Particle) o2;
    p2.delete();
  }

  if (o1.getClass() == Boundary.class) {
    Particle p = (Particle) o2;
    p.change();
  }
  if (o2.getClass() == Boundary.class) {
    Particle p = (Particle) o1;
    p.change();
  }
}
void endContact(Contact cp) {
}