extends CharacterBody2D

class_name Enemy

@export var patrol_point_parent: Node

@export var target_node: Node2D

@export var speed: float = 30

@export var patrol_max_radius: float = 20

@onready var health_system = $HealthSystem

@onready var aim_system = $AimSystem

var rand: RandomNumberGenerator

var current_patrol_target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	aim_system.init(target_node)
	
	rand = RandomNumberGenerator.new()

func _physics_process(delta):

	if current_patrol_target == null or global_position.distance_to(current_patrol_target.global_position) < patrol_max_radius:
		current_patrol_target = patrol_point_parent.get_children()[rand.randi_range(0, patrol_point_parent.get_children().size() - 1)]
	
	velocity += (current_patrol_target.position - global_position).normalized() * speed * delta
	
	move_and_slide()
	
	
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

