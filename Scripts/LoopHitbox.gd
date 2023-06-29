extends Area2D

@export var lifespan: float = 0.5

@onready var polygon_visuals: Polygon2D = $Polygon2D
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D

func init(points: PackedVector2Array):
	polygon_visuals.polygon = points
	collision_polygon.polygon = points
	
	polygon_visuals.modulate = Color(1, 1, 1, 0)
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(polygon_visuals, "modulate", Color(1, 1, 1, 1), lifespan * 0.25)
	tween.tween_property(polygon_visuals, "modulate", Color(1, 1, 1, 0), lifespan * 0.75)
	tween.tween_callback(queue_free)

func _on_area_entered(area: Area2D):
	
	if area is Projectile:
		print(area)
