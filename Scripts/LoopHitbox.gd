extends Area2D

@export var lifespan: float = 0.5
@export var position_offset: Vector2 = Vector2.ZERO

@onready var polygon_visuals: Polygon2D = $Polygon2D
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D

var loop_owner: Node2D

func init(new_loop_owner: Node2D, points: PackedVector2Array):
	
	loop_owner = new_loop_owner
	
	polygon_visuals.polygon = points
	collision_polygon.polygon = points
	
	# The offset helps it align better with the LineDrawer
	collision_polygon.position = position_offset
	polygon_visuals.position = position_offset
	
	polygon_visuals.modulate = Color(1, 1, 1, 0)
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(polygon_visuals, "modulate", Color(1, 1, 1, 1), lifespan * 0.25)
	tween.tween_callback(func(): collision_polygon.disabled = true)
	tween.tween_property(polygon_visuals, "modulate", Color(1, 1, 1, 0), lifespan * 0.75)
	tween.tween_callback(queue_free)

func _on_area_entered(area: Area2D):
	
	if area is Projectile:
		
		area.change_owner(loop_owner)
		area.return_to_owner()
