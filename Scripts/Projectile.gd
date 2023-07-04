extends Area2D

class_name Projectile

enum State {IDLE, TRAVELLING, RETURNING}

@export var speed: float = 60
@export var return_speed: float = 250
@export var lifespan: float = 5

var current_state: State = State.TRAVELLING

var original_owner: Node2D
var current_owner: Node2D

# Team system is gross workaround to make enemies not be able to hit each other
enum TEAM {PLAYER, ENEMY}
var current_team: TEAM = TEAM.ENEMY

func init(projectile_owner: Node2D):
	original_owner = projectile_owner
	change_owner(projectile_owner)
	
	if projectile_owner is Enemy:
		current_team = TEAM.ENEMY
	elif projectile_owner is Player:
		current_team = TEAM.PLAYER
	
	get_tree().create_timer(lifespan).timeout.connect(queue_free)

func _process(delta):
	
	if current_state == State.TRAVELLING:
		position += transform.x * speed * delta
	elif current_state == State.RETURNING:
		
		position += transform.x * speed * delta
		
		if is_instance_valid(original_owner):
			rotation = lerp_angle(rotation, rotation + get_angle_to(original_owner.global_position), delta * 20)

func change_owner(new_owner: Node2D):
	current_owner = new_owner
	
	if current_owner is Enemy:
		current_team = TEAM.ENEMY
	elif current_owner is Player:
		current_team = TEAM.PLAYER

func slow():
	
	if current_state != State.TRAVELLING:
		return
		
	current_state = State.IDLE
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", position + transform.x * 20, 0.3)


func return_to_owner():	
	if is_instance_valid(original_owner):
		rotation = rotation + get_angle_to(original_owner.global_position)
			
	current_state = State.RETURNING
	speed = return_speed
		

func can_damage(node: Node2D) -> bool:
	
	if (node is Enemy and current_team == TEAM.ENEMY) \
		or (node is Player and current_team == TEAM.PLAYER):
		
		return false
	else: 
		return node != current_owner
