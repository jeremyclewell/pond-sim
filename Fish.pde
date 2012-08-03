
// The Fish class

/* To optimize:
  
    
    run method param araylist friends => recursive School
    
    update state machine only once ever 3-4 frames


*/


WanderState wanderState;
ShelterState shelterState;
RomanceState romanceState;
HuntState huntState;
FleeState fleeState;

State state;

class Fish {

  PVector loc;
  PVector vel;
  PVector acc;
  PVector nearby;
  float r = 3.0;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  int mass;
  int energy;
  int age;
  int type;
  color strokeCol;
  Fish fishOfInterest;
  int stateLabel;
  boolean hungry;
  boolean markedForDeletion;
  boolean markedForReproduction;
  School school;
  PImage img;

  /* 
   State Legend
   
   0 = wander
   1 = shelter
   2 = romance
   3 = hunt
   4 = flee
   
   */


  //bigFish 1
  //littleFish 2
  Fish(PVector l, float ms, float mf, int t, School school) {
    acc = new PVector(0,0);
    vel = new PVector(random(-1,1),random(-1,1));
    loc = l.get();
    maxspeed = ms;
    maxforce = mf;
    // state = 0;
    age = int(random(0, 700));
    type = t;
    hungry = false;
    markedForDeletion = false;
    markedForReproduction = false;
    school = school;
    switch (type) {
    case 1:
     mass = 30;
      energy = int(random(2000, 3000));
      img = loadImage("fish.png");
      break;
    
    case 2:
     mass = 50;
      energy = int(random(2000, 3000));
      img = loadImage("bigFish.png");
      break;
      
    case 3:
      mass = 20;
      energy = int(random(30000, 40000));
      strokeCol = color(0, 200, 50, 10);
      break;
    }
    state = (State) new WanderState(this);
    stateLabel = 1;
  }

  void run(ArrayList freinds, School predadors, School prey) {
    if (energy <= 0) markedForDeletion = true;
    if (type == 3) {
      energy += 5;
      borders();
      render();
      return;
    }
    energy--;
    age++;
    if (energy < 2000) hungry = true;
    if (energy > 2500) hungry = false;

    //if (milli() % 3 == 0) state = (State) getState(freinds, opponents); // try to minimize the number of times we change the state...
    state = (State) getState(freinds, predadors, prey);
    state.update(this, freinds, predadors, prey);

    borders();
    render();
  }

  State getState(ArrayList friends, School predadors, School prey) {
    /*
    
     Orginize how we want to determine "Fish of interest" for each predador and prey
     
     
     */
    int count = 0;
    State newState;
    // newState = new WanderState(this);
    //  newState = new ShelterState(this);
    stateLabel = 0;
    if (predadors != null) {
      for (int i = 0 ; i < predadors.fish.size(); i++) {
        Fish other = (Fish) predadors.fish.get(i);
        float d = PVector.dist(loc,other.loc);
        if ((d > 0) && (d < 5500) && (other.mass > mass)) {
          stateLabel = 1; // Shelter State
          count++;
        }
      }
    }
    
    
    if ((energy > 4000) && (age > 1500) && (age < 3500)) {  
      ArrayList possibleMates = new ArrayList();
        for (int i = 0 ; i < friends.size(); i++) {
          Fish other = (Fish) friends.get(i);
          float d = PVector.dist(loc,other.loc);
          if ((d > 0) && (d < 100)) {
            if (other.energy > 4000 && other.age > 1500 && other.age < 3500) {
              possibleMates.add(other);
            }
          }
        }
        float d3 = 1000.0;
        for (int j = 0 ; j < possibleMates.size(); j++) {
          Fish other2 = (Fish) possibleMates.get(j);
          float d2 = PVector.dist(loc,other2.loc);
          if ((d3 > d2)) {
            d3 = d2;
            fishOfInterest = other2;
            stateLabel = 2; 
            if (d2 < 20 && fishOfInterest.stateLabel == 2) {
              
              energy /= 2;
              markedForReproduction = (random(0, 10) >= 5) ? true : false;
           //    school.addFish(new Fish(loc, maxspeed, maxforce, type, school));
            }

          }
        }
      // stateLabel = 2;  // Romance State
    }
    if (prey != null) {
      if (hungry) {
        ArrayList possiblePrey = new ArrayList();
        for (int i = 0 ; i < prey.fish.size(); i++) {
          Fish other = (Fish) prey.fish.get(i);
          float d = PVector.dist(loc,other.loc);
          if ((d > 0) && (d < 100)) {
            if (other.mass < mass) {
              possiblePrey.add(other);
            }
          }
        }
        float d3 = 1000.0;
        for (int j = 0 ; j < possiblePrey.size(); j++) {
          Fish other2 = (Fish) possiblePrey.get(j);
          float d2 = PVector.dist(loc,other2.loc);
          if ((d3 > d2)) {
            d3 = d2;
            fishOfInterest = other2;
            stateLabel = 3; 
            if (d2 < 20) {
              other2.energy -= 50;
              energy += 50;
            }
            count++;
          }
        }
      }
    }


    if (predadors != null) {
      ArrayList possibleAttackers = new ArrayList();
      for (int i = 0 ; i < predadors.fish.size(); i++) {
        Fish other = (Fish) predadors.fish.get(i);
        float d = PVector.dist(loc,other.loc);
        if ((d > 0) && (d < 60)) {
          if (other.mass > mass) {
            possibleAttackers.add(other);
          }
        }
      }
      float d3 = 1000.0;
      for (int j = 0 ; j < possibleAttackers.size(); j++) {
        Fish other2 = (Fish) possibleAttackers.get(j);
        float d2 = PVector.dist(loc,other2.loc);
        if ((d3 > d2)) {
          d3 = d2;
          fishOfInterest = other2;
          stateLabel = 4;
          count++;
        }
      }
    }

    switch (stateLabel) {
    case 4: 
      newState = new FleeState(this);
      break;
    case 3:
      newState = new HuntState(this);
      break;
    case 2:
      newState = new RomanceState(this);
      break;
    case 1:
      newState = new ShelterState(this);
      break;
    default:
      newState = new WanderState(this);
      break;
    }
    return newState;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = vel.heading2D() + PI/2;
      fill(strokeCol);
    if (stateLabel == 2) {
      strokeCol = color(100, 250, 250);
      //ellipse(0, 0, energy/100, energy/100);
    }
    if (stateLabel == 3) strokeCol = color(200, 200, 200); 
    if (stateLabel == 4) strokeCol = color(0, 200, 0);
//    println(age);
    stroke(strokeCol);
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(theta);
    r = mass*.03;
    float v = 2.0;
    if (type == 3) {
      ellipse(loc.x, loc.y, energy/3000, energy/3000);
    } 
    else {
//    float fishScale = type;
    image(img, 0, 0);
// beginShape();
//vertex( 0.02 * fishScale , 0.22 * fishScale );
//bezierVertex( 0.02 * fishScale, 0.22 * fishScale, -3.5 * fishScale, 1.73 * fishScale, -3.5 * fishScale, 6.93 * fishScale);
//vertex( -3.66 * fishScale, 11.79 * fishScale);
//bezierVertex( -3.66 * fishScale, 11.79 * fishScale, -8.19 * fishScale, 12.29 * fishScale, -9.2 * fishScale, 14.14 * fishScale);
//vertex( -4.0 * fishScale, 17.16 * fishScale);
//bezierVertex( -4.0 * fishScale, 17.16 * fishScale, -2.32 * fishScale, 20.85 * fishScale, -1.99 * fishScale, 22.35 * fishScale);
//bezierVertex( -1.99 * fishScale, 22.35 * fishScale, -0.48 * fishScale, 25.21 * fishScale, -0.48 * fishScale, 26.71 * fishScale);
//vertex( -0.81 * fishScale, 30.91 * fishScale);
//vertex( 1.02 * fishScale, 31.41 * fishScale);
//bezierVertex( 1.02 * fishScale, 31.41 * fishScale, 1.19 * fishScale, 27.39 * fishScale, 1.02 * fishScale, 26.88 * fishScale);
//bezierVertex( 1.02 * fishScale, 26.88 * fishScale, 1.36 * fishScale, 22.69 * fishScale, 2.03 * fishScale, 22.19 * fishScale);
//vertex( 3.37 * fishScale, 17.16 * fishScale);
//vertex( 9.24 * fishScale, 15.65 * fishScale);
//bezierVertex( 9.24 * fishScale, 15.65 * fishScale, 3.54 * fishScale, 11.29 * fishScale, 3.37 * fishScale, 11.29 * fishScale);
//bezierVertex( 3.37 * fishScale, 11.29 * fishScale, 3.03 * fishScale, 7.77 * fishScale, 3.03 * fishScale, 7.26 * fishScale);
//vertex( 0.52 * fishScale, 0.72 * fishScale);     
//endShape();

    }
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (loc.x < -r) loc.x = width+r;
    if (loc.y < -r) loc.y = height+r;
    if (loc.x > width+r) loc.x = -r;
    if (loc.y > height+r) loc.y = -r;
  }
}


