class WanderState extends State
{
  int label = 0;
  PVector wanderTarget;
  float wanderJitter = .03;
  float wanderRadius = 1000;
  float wanderProjectedDist = 100;
  PVector loc;
  PVector vel;
  PVector acc;
  float r = 3.0;
  float maxforce;    // Maximum steering force
  float maxspeed;

  

  WanderState(Fish current) {
    loc = current.loc;
    vel = current.vel;
    acc = current.acc;
    vel.normalize();
    wanderTarget = vel;
    r = current.r;
    maxforce = current.maxforce ;
    maxspeed = current.maxspeed ;
  }

  void update(Fish current, ArrayList fish, School predadors, School prey) {
    wanderTarget.add(new PVector(random(-wanderJitter, wanderJitter), random(-wanderJitter, wanderJitter)));
    wanderTarget.normalize();
    wanderTarget.mult(wanderRadius);
    wanderTarget.add(PVector.mult(vel, wanderProjectedDist));
    seek(wanderTarget);
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
    vel.mult(0.99);
  }

  void seek(PVector target) {
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
