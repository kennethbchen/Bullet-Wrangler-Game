extends CharacterBody2D

@export var speed: float = 75

@onready var health_system: HealthSystem = $HealthSystem
@onready var attack_system = $AttackSystem

var input_dir : Vector2

signal player_died()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
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
	
func _physics_process(delta):
	
	velocity = input_dir * speed
	move_and_slide()

func take_damage(damage: int):
	health_system.change_health(-abs(damage))
	
func _on_health_zeroed():
	player_died.emit()
	print("ded")

func _on_hurtbox_area_entered(area: Area2D):
	
	if area is Projectile:
		
		var proj = area as Projectile
	
		if proj.can_damage(self):
			take_damage(1)
			proj.queue_free()
			
func _on_hurtbox_body_entered(body: Node2D):
	
	if body is Enemy:
		take_damage(1)
