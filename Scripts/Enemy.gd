extends CharacterBody2D

class_name Enemy

@export var target_node: Node2D

@onready var health_system = $HealthSystem

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damage: int):
	health_system.change_health(-abs(damage))

func _on_health_zeroed():
	queue_free()

func _on_hurtbox_area_entered(area: Area2D):
	
	if area is Projectile:
		
		var proj = area as Projectile
		
		if proj.can_damage(self):
			take_damage(1)
			proj.queue_free()

