extends Area2D

class_name Projectile

@export var speed: float = 60
@export var lifespan: float = 5

var original_owner: Node2D
var current_owner: Node2D

func init(owner: Node2D):
	original_owner = owner
	current_owner = owner
	
	get_tree().create_timer(lifespan).timeout.connect(queue_free)

func _ready():
	pass

func _process(delta):
	position += transform.x * speed * delta

func change_owner(new_owner: Node2D):
	current_owner = new_owner

func return_to_owner():
	transform.x = -transform.x

func _on_area_entered(area: Area2D):
	
	if area == current_owner:
		return
	
	if area.has_method("take_damage"):
		area.take_damage(1)
		queue_free()
