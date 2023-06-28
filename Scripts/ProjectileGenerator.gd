extends Node2D

@export var projectile_scene: PackedScene

@export var spawn_delay: float = 1

@export var even_offset: Vector2

@onready var spawn_point_parent: Node = $SpawnPoints

@onready var delay_timer: Timer = $DelayTimer


func _ready():
	assert(projectile_scene != null)
	
	delay_timer.wait_time = spawn_delay
	delay_timer.start()

func _process(delta):
	pass
	
func _on_delay_timer_timeout():
	
	for child in spawn_point_parent.get_children():
		
		var new_projectile = projectile_scene.instantiate()
		get_tree().root.add_child(new_projectile)
		new_projectile.global_position = child.global_position
		new_projectile.rotation = child.rotation
	
	
	if spawn_point_parent.position == Vector2.ZERO:
		spawn_point_parent.position = even_offset
	else:
		spawn_point_parent.position = Vector2.ZERO
		
	print(spawn_point_parent.position)
	
