# Procedural Maze Generator (Godot 4)

This script generates a procedural maze in a `Node2D` scene using recursive backtracking, with optional loop creation for more complex paths.

## Features

- Procedural maze generation (DFS backtracking)
- Random loops for non-perfect mazes
- Collision-enabled walls (`StaticBody2D`)
- Wall metadata system
- Border detection

---

## Usage

1. Attach the script to a `Node2D`.
2. Run the scene.
3. The maze is generated automatically.

---

## Configuration

You can modify the maze with these variables:

- `columnas`: number of columns
- `filas`: number of rows
- `tam`: size of each cell (pixels)

---

## Wall System

Each wall is instantiated as a `StaticBody2D` with:

### Collision
- `CollisionShape2D` (RectangleShape2D)
- Fully solid by default

### Metadata

Walls store metadata using `set_meta()`:

- `destruible` → whether the wall can be destroyed
- `borde` (implicit via generation logic) → indicates if the wall belongs to the outer boundary of the maze

---

## Generation Logic

- Maze is generated using recursive depth-first search
- Walls between cells are removed via `romper_pared()`
- Extra loops are added via `agregar_loops()` to avoid a perfect tree structure
