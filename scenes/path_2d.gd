# Editor tool that uses a Line2D to visualize a Path2D
# To use it, attach this script to a Path2D, and then save, close, and re-open the scene
@tool
extends Path2D

@export var line: Line2D

## Controls whether the path is treated as static (only update in editor) or dynamic (can be updated during runtime)
## If you set this to true, be alert for potential performance issues
@export var update_curve_at_runtime: bool = false

func _ready():
	#Add a line if it doesn't exist
	#The line will be saved as part of the scene, so this will only run once
	if Engine.is_editor_hint():		
		if line == null:
			line = Line2D.new()
			set_line_defaults()
			line.points= curve.tessellate()
			#Lock the line to prevent accidental changes
			lock_node(line)

			#Add the line and set it to save as part of the current scene
			add_child(line)
			line.owner=owner

	#In theory, _enter_tree should have already done this, but just to be safe...
	if Engine.is_editor_hint() or update_curve_at_runtime:
		if not curve.changed.is_connected(curve_changed):
			curve.changed.connect(curve_changed)

#Wire up signals on enter tree, since they are removed in exit tree
func _enter_tree():
	if Engine.is_editor_hint() or update_curve_at_runtime:
		if not curve.changed.is_connected(curve_changed):
			curve.changed.connect(curve_changed)

#Clean up signals (ie. when closing scene) to prevent error messages in the editor
func _exit_tree():
	if curve.changed.is_connected(curve_changed):
		curve.changed.disconnect(curve_changed)

func curve_changed():
	line.points=curve.tessellate()

#Sets the editor lock on a node, to prevent accidental changes
#Based on https://github.com/godotengine/godot-proposals/issues/3046
func lock_node(node:Node):
	node.set_meta("_edit_lock_", true);

#Newly added lines will have these settings by default
#Feel free to change these if you'd rather different defaults
func set_line_defaults():
	line.begin_cap_mode= Line2D.LINE_CAP_ROUND
	line.joint_mode=Line2D.LINE_JOINT_ROUND
	line.width = 10
	line.width_curve = make_default_curve()
	line.name = name+"_line"

#Makes a simple s-shaped curve going from high to low value
#This makes the curve start out wide, but end in a point.
func make_default_curve():
	var retval = Curve.new()
	retval.min_value = 0
	retval.max_value = 1
	retval.add_point(Vector2(0,1))
	retval.add_point(Vector2(1,0))

	return retval
