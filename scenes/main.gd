extends Node2D

@onready var sine_wave: Node2D = $SineWave
@onready var path: Node2D = $SineWave/Path2D
@onready var dragger: Node2D = $Dragger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path.curve.set_point_position(1, Vector2(remap(dragger.position.x, 0, 1280, -640, 640), remap(dragger.position.y, 0, 720, -360, 360)))
	path.curve.set_point_position(0, Vector2(0, -remap(dragger.position.y, 0, 720, -360, 360)))
	path.curve.set_point_in(1, Vector2(path.curve.get_point_position(1).x/-2, 0))
	path.curve.set_point_out(0, Vector2(path.curve.get_point_position(1).x/2, 0))
