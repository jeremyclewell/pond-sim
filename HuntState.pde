class HuntState extends State
{

  int label = 3;
   PVector loc;
  PVector vel;
  PVector acc;
  PVector nearby;
  Fish target;
  float r = 3.0;
  float maxforce;    // Maximum steering force
  float maxspeed;

  HuntState(Fish current) {
    loc = current.loc;
    vel = current.vel;
    acc = current.acc;
    r = current.r;
    target = current.fishOfInterest;
    maxforce = current.maxforce + .025;
    maxspeed = current.maxspeed + 10;
  }

  void update(Fish current, ArrayList fish, School predadors, School prey) {
    arrive(target.loc);
    //flock(fish, current);
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0); 
    vel.mult(1.001);
  }

  void flee(PVector target) {
    acc.add(steer(target,false));
  }

  void arrive(PVector target) {
    acc.add(steer(target,true));
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  PVector steer(PVector target, boolean slowdown) {
    PVector steer;  // The steering vector
    PVector desired = target.sub(target, loc);  // A vector pointing from the location to the target
    float d = desired.mag(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 100.0)) desired.mult(maxspeed*(d/100.0)); // This damping is somewhat arbitrary
      else desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      steer = target.sub(desired,vel);
      steer.limit(maxforce);  // Limit to maximum steering force
    } 
    else {
      steer = new PVector(0,0);
    }
    return steer;
  }
 
    
  
  
}

