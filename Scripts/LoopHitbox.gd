extends Area2D

@export var lifespan: float = 0.5
@export var position_offset: Vector2 = Vector2.ZERO
@export var shoot_delay: float = 0.2

@onready var polygon_visuals: Polygon2D = $Polygon2D
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D

var loop_owner: Node2D

var detected_projectiles: Array[Projectile] = []

signal sound_requested(name: String)

func init(new_loop_owner: Node2D, points: PackedVector2Array):
	
	loop_owner = new_loop_owner
	
	polygon_visuals.polygon = points
	collision_polygon.polygon = points
	
	# The offset helps it align better with the LineDrawer
	collision_polygon.position = position_offset
	polygon_visuals.position = position_offset
	
	polygon_visuals.modulate = Color(1, 1, 1, 0)
	
	sound_requested.emit("attack1")
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(polygon_visuals, "modulate", Color(1, 1, 1, 1), lifespan * 0.35)
	tween.tween_callback(func(): collision_polygon.disabled = true)
	tween.tween_property(polygon_visuals, "modulate", Color(1, 1, 1, 0), lifespan * 0.65)
	tween.tween_callback(func():
		for projectile in detected_projectiles:
			
			projectile.change_owner(loop_owner)
			projectile.return_to_owner()
			
			sound_requested.emit("attack2")
			await get_tree().create_timer(shoot_delay).timeout
			
		)

func _on_area_entered(area: Area2D):
	
	
	if area is Projectile:
		
		detected_projectiles.push_back(area)
		area.slow()
