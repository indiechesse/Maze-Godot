extends Node2D

# Maze size
@export var columnas = 12
@export var filas = 12

# Size of each cell
@export var tam = 64

# Stores all maze data
var grid = []

# Possible directions
var dirs = [
	Vector2i(1,0),
	Vector2i(-1,0),
	Vector2i(0,1),
	Vector2i(0,-1)
]


func _ready():

	randomize()

	crear_grid()

	generar(0, 0)

	# Adds extra paths and loops
	agregar_loops(20)

	dibujar()



# Creates the base grid
func crear_grid():

	grid.clear()

	for y in range(filas):

		var fila = []

		for x in range(columnas):

			fila.append({
				"visitado": false,
				"top": true,
				"bottom": true,
				"left": true,
				"right": true
			})

		grid.append(fila)



# Recursive maze generation
func generar(x, y):

	grid[y][x]["visitado"] = true

	var direcciones = dirs.duplicate()

	direcciones.shuffle()

	for d in direcciones:

		var nx = x + d.x
		var ny = y + d.y

		if dentro(nx, ny):

			if !grid[ny][nx]["visitado"]:

				romper_pared(x, y, nx, ny)

				generar(nx, ny)



# Removes walls between two cells
func romper_pared(x1, y1, x2, y2):

	var dx = x2 - x1
	var dy = y2 - y1

	if dx == 1:

		grid[y1][x1]["right"] = false
		grid[y2][x2]["left"] = false

	elif dx == -1:

		grid[y1][x1]["left"] = false
		grid[y2][x2]["right"] = false

	elif dy == 1:

		grid[y1][x1]["bottom"] = false
		grid[y2][x2]["top"] = false

	elif dy == -1:

		grid[y1][x1]["top"] = false
		grid[y2][x2]["bottom"] = false



# Adds random extra connections
func agregar_loops(cantidad):

	for i in range(cantidad):

		var x = randi_range(0, columnas - 2)
		var y = randi_range(0, filas - 2)

		var d = dirs.pick_random()

		var nx = x + d.x
		var ny = y + d.y

		if dentro(nx, ny):

			romper_pared(x, y, nx, ny)



# Checks if a cell is inside the grid
func dentro(x, y):

	return x >= 0 and y >= 0 and x < columnas and y < filas



# Draws all walls
func dibujar():

	# Removes old walls before redrawing
	for c in get_children():

		if c != self:

			c.queue_free()

	for y in range(filas):

		for x in range(columnas):

			var cell = grid[y][x]

			var px = x * tam
			var py = y * tam

			# Top wall
			if cell["top"]:

				spawn_wall(
					Vector2(px + tam / 2.0, py),
					Vector2(tam, 6),
					y != 0
				)

			# Left wall
			if cell["left"]:

				spawn_wall(
					Vector2(px, py + tam / 2.0),
					Vector2(6, tam),
					x != 0
				)

			# Bottom border wall
			if y == filas - 1 and cell["bottom"]:

				spawn_wall(
					Vector2(px + tam / 2.0, py + tam),
					Vector2(tam, 6),
					false
				)

			# Right border wall
			if x == columnas - 1 and cell["right"]:

				spawn_wall(
					Vector2(px + tam, py + tam / 2.0),
					Vector2(6, tam),
					false
				)



# Creates a wall
func spawn_wall(pos, size, destruible):

	var body = StaticBody2D.new()

	# Defines if the wall can be destroyed
	body.set_meta("destruible", destruible)

	var collision = CollisionShape2D.new()

	var shape = RectangleShape2D.new()

	shape.size = size

	collision.shape = shape

	body.add_child(collision)

	# Simple visual
	var visual = ColorRect.new()

	visual.size = size

	visual.color = Color.BLACK

	visual.position = Vector2(
		-size.x / 2.0,
		-size.y / 2.0
	)

	body.add_child(visual)

	body.position = pos

	# Adds wall directly to the current node
	add_child(body)