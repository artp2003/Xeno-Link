@tool
extends Control

@export var color: Color = Color.WHITE:
	set(_color):
		color = _color
		queue_redraw()

@export var width: float = -1.0:
	set(_width):
		width = _width
		if width <= 0:
			width = -1
		queue_redraw()

@export var antialiasing: bool = false:
	set(_antialiasing):
		antialiasing = _antialiasing
		queue_redraw()

@export var frequency: float = 1.0:
	set(_frequency):
		frequency = _frequency
		queue_redraw()

@export var amplitude: float = 1.0:
	set(_amplitude):
		amplitude = _amplitude
		queue_redraw()

func _ready() -> void:
	resized.connect(queue_redraw)
	queue_redraw()	
	
func _draw() -> void:
	var points: PackedVector2Array
	for x: int in floori(size.x):
		var x_centered:= x - size.x / 2.0
		points.append(Vector2(x, size.y/ 2.0 + sin((x_centered / size.x)* TAU * frequency) * amplitude))
		draw_polyline(points, color, width, antialiasing)
