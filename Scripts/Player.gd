extends CharacterBody2D

class_name Player

@export var speed: float = 75
@export var invulnerability_duration: float = 1

@onready var health_system: HealthSystem = $HealthSystem
@onready var attack_system = $AttackSystem

var input_dir : Vector2

var alive: bool = true

var invulnerable = false

signal player_died()



# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not alive: return
	
	input_dir = Vector2.ZERO
	
	if Input.is_action_pressed("Up"):
		input_dir.y -= 1
	
	if Input.is_action_pressed("Down"):
		input_dir.y += 1
		
	if Input.is_action_pressed("Left"):
		input_dir.x -= 1

	if Input.is_action_pressed("Right"):
		input_dir.x += 1
	
	if Input.is_action_pressed("Attack"):
		attack_system.try_attack()
		
	input_dir = input_dir.normalized()
	
func _physics_process(delta):
	
	velocity = input_dir * speed
	move_and_slide()

func take_damage(damage: int):
	health_system.change_health(-abs(damage))
	invulnerable = true
	get_tree().create_timer(invulnerability_duration).timeout.connect(_on_invulnerability_timeout)
	
func _on_health_zeroed():
	player_died.emit()
	alive = false
	input_dir = Vector2.ZERO

func _on_hurtbox_area_entered(area: Area2D):
	
	if area is Projectile:
		
		var proj = area as Projectile
	
		if not invulnerable and proj.can_damage(self):
			take_damage(1)
			proj.queue_free()
			
func _on_hurtbox_body_entered(body: Node2D):
	
	if body is Enemy:
		take_damage(1)
		

func _on_invulnerability_timeout():
	invulnerable = false
