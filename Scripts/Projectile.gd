extends Area2D

class_name Projectile

enum State {IDLE, TRAVELLING, RETURNING}

@export var speed: float = 60
@export var lifespan: float = 5

var current_state: State = State.TRAVELLING

var original_owner: Node2D
var current_owner: Node2D

func init(owner: Node2D):
	original_owner = owner
	current_owner = owner
	
	get_tree().create_timer(lifespan).timeout.connect(queue_free)

func _ready():
	pass

func _process(delta):
	
	if current_state == State.TRAVELLING:
		position += transform.x * speed * delta
	elif current_state == State.RETURNING:
		
		position += transform.x * speed * delta
		
		if is_instance_valid(original_owner):
			rotation = lerp_angle(rotation, rotation + get_angle_to(original_owner.global_position), delta * 10)


func change_owner(new_owner: Node2D):
	current_owner = new_owner

func return_to_owner():
	
	if current_state != State.TRAVELLING:
		return
		
	current_state = State.IDLE
	

	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", position + transform.x * 10, 0.3)
	tween.tween_callback(func(): 
		
		if is_instance_valid(original_owner):
			rotation = rotation + get_angle_to(original_owner.global_position)
			
		current_state = State.RETURNING
		speed = speed + 80
		)

func _on_area_entered(area: Area2D):
	
	if area == current_owner:
		return
	
	if area.has_method("take_damage"):
		area.take_damage(1)
		queue_free()
