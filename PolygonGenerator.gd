extends Node

@export var polygon_scene: PackedScene

func _ready():
	assert(polygon_scene != null, "Polygon Generator must have polygon scene.")

func generate_polygon(points: PackedVector2Array):
	
	var new_poly = polygon_scene.instantiate()
	add_child(new_poly)
	new_poly.init(points)
	
func _on_loop_created(line_drawer, points: PackedVector2Array):
	
	if points.size() == 0:
		return
	
	generate_polygon(points)
	line_drawer.clear_points()
