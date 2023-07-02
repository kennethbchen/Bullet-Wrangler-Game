extends Node

enum State {IDLE, CHARGED}

@export var polygon_scene: PackedScene

@onready var line_drawer: = $LineDrawer

var current_state: State = State.IDLE
var current_polygon: PackedVector2Array

func _ready():
	assert(line_drawer != null, "Attack system must have line_drawer.")
	assert(polygon_scene != null, "Attack system must have polygon_scene.")

func try_attack():
	if current_state != State.CHARGED: return
	
	current_state = State.IDLE
	
	generate_polygon(current_polygon)
	current_polygon = PackedVector2Array()
	
	line_drawer.clear_points()
	line_drawer.enabled = true
	
func generate_polygon(points: PackedVector2Array):
	
	var new_poly = polygon_scene.instantiate()
	add_child(new_poly)
	new_poly.init(get_parent(), points)

func _on_loop_created(affected_line_drawer, points : PackedVector2Array):
	
	if points.size() == 0: return
		
	affected_line_drawer.enabled = false
	
	current_polygon = points
	
	current_state = State.CHARGED
