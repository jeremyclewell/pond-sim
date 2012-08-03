import processing.opengl.*;

School littleFishes;
School bigFishes;
School plants;
import fullscreen.*; 


SoftFullScreen fs; 
color bg;

void setup() {
  size(1650, 1060, OPENGL);
  littleFishes = new School();
  // Add an initial set of fish into the system
  for (int i = 0; i < 175; i++) {
    littleFishes.addFish(new Fish(new PVector(int(random(width)),int(random(height))), 0.8, 0.009, 1, littleFishes));
  }

  bigFishes = new School();
  // Add an initial set of fish into the system
  for (int i = 0; i < 9; i++) {
    bigFishes.addFish(new Fish(new PVector(int(random(width)),int(random(height))), 0.6, 0.009, 2, bigFishes));
  }
  
  plants = new School();
  // Add an initial set of fish into the system
  for (int i = 0; i < 35; i++) {
    plants.addFish(new Fish(new PVector(int(random(width)),int(random(height))), 0, 0, 3, plants));
  }
  
  littleFishes.addPrey(plants);
  littleFishes.addPredador(bigFishes);
  bigFishes.addPrey(littleFishes);
  smooth();
  
    fs = new SoftFullScreen(this); 
fs.enter(); 
}

void draw() {
  fill(0,20);
  rect(-1,-1,width+2,height+2);      
  // background(10, 250);
  littleFishes.run();
  println(littleFishes.population());
  bigFishes.run();
  plants.run();
}

// Add a new boid into the System
void mousePressed() {
 // littleFishes.addFish(new Fish(new PVector(mouseX,mouseY),2.0f,0.05f));
   littleFishes.addFish(new Fish(new PVector(int(random(width)),int(random(height))), 0, 0, 3, plants));
}



