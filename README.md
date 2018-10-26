# Best-First Search Pathfinding

[Demo (Outdated)](https://www.youtube.com/watch?v=RE1eep3BBhY)

Calculates a path once per grid arrangement for all entities to follow towards a goal. Uses best-first search to do a single-pass over the grid and mark each cell with the 'next' option an entity should take, routing to the goal.

Changing obstacles or moving the goal will cause the algorithm to re-run and a new pathing map to generate.

## Controls

* Space (hold) - Spawns new entities at the current spawn points (blue)
* Mouse 1 - Add/Remove an obstacle at the mouse's position
* Mouse 2 - Create a new entity at the mouse's position
* SHIFT + Mouse 1 - Create an entity spawner at the mouse's position
* SHIFT + Mouse 2 - Relocate the goal to the mouse's position
* [DEBUG] F1 - Restart
* [DEBUG] F2 - Show calculated distance map
