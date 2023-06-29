extends Node

enum State {IDLE, CHARGED}

@onready var line_drawer: = $LineDrawer
@onready var polygon_generator: = $PolygonGenerator

var current_state: State = State.IDLE
var current_polygon: PackedVector2Array

func _ready():
	assert(line_drawer != null)
	assert(polygon_generator != null)

func try_attack():
	if current_state != State.CHARGED: return
	
	current_state = State.IDLE
	
	polygon_generator.generate_polygon(current_polygon)
	current_polygon = PackedVector2Array()
	
	line_drawer.clear_points()
	line_drawer.enabled = true

func _on_loop_created(line_drawer, points : PackedVector2Array):
	
	if points.size() == 0: return
		
	line_drawer.enabled = false
	
	current_polygon = points
	
	current_state = State.CHARGED
