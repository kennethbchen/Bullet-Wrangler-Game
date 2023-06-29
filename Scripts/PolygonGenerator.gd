extends Node

@export var polygon_scene: PackedScene

func _ready():
	assert(polygon_scene != null, "Polygon Generator must have polygon scene.")

func generate_polygon(points: PackedVector2Array):
	
	var new_poly = polygon_scene.instantiate()
	add_child(new_poly)
	new_poly.init(points)
