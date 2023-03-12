this is not functional yet

thoughts:
* a mob is composed of traits
* traits are like "sees", "wanders", "tames", "suffocates"
* defining a mob is done by defining individual traits

* a mob will be engaged in one action at a time - this defines its state
* states are like "moving", "interacting w/ world", "interacting w/ object"
* state is recomputed at the start of every tick
* states live in a priority queue; whichever state has the highest priority, is what we are doing
* if the state changes, wrap up the old state, start the new state, then do the new state
* some traits (not all of them) are purely reactionary - they .
* some traits define what a player can do to a mob (tamable, feedable)
