extends Area2D

@export var speed: float = 75

@onready var health_system: HealthSystem = $HealthSystem
@onready var attack_system = $AttackSystem

var input_dir : Vector2

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
	
	position += input_dir * speed * delta

func _on_area_entered(area : Area2D):
	if area is Enemy:
		take_damage(-1)

func take_damage(damage: int):
	print("ow")
	health_system.change_health(-abs(damage))
	
func _on_health_zeroed():
	print("ded")

