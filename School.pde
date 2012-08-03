// The School (a list of Fish objects)

class School {
  ArrayList fish; // An arraylist for all the fish
  School predadors;
  School prey;

  School() {
    fish = new ArrayList(); // Initialize the arraylist
  }

  void run() {
    for (int i = 0; i < fish.size(); i++) {
      Fish b = (Fish) fish.get(i);  
  //    predadors = (predadors !=  null) ? predadors : null;
    //  prey = (prey != null) ? prey : null;
      if (b.markedForDeletion == true) fish.remove(i);
      if (b.markedForReproduction == true) {
        addFish(new Fish(b.loc, b.maxspeed, b.maxforce, b.type, this));
        b.markedForReproduction = false;
      }
      b.run(fish, predadors, prey); // Passing the entire list of fish to each boid individually
    }
  }

  void addFish(Fish b) {
    fish.add(b);
  }
  
  void addPredador(School predador) {
    predadors = predador;
  }
  
  void addPrey(School food) {
    prey = food;
  }
  
  int population() {
    return fish.size();
  }

}

