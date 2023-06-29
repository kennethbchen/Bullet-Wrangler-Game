extends Node2D

@export var run_forever = false

@export var steps: Array[ProjectileGeneratorStep]

var running : bool = false

func _ready():
	pass


func _process(delta):
	
	if Input.is_action_just_pressed("DebugSpawn"):
		start()
		
	if run_forever and not running:
		start()

func start():
	
	if running: return
	
	running = true
	for step in steps:
		
		if step.skip:
			continue
		
		var spawn_pos_parent = get_node(step.spawn_position_parent_path)
		
		for step_cycle in range(0, step.step_cycles):
			
			# Apply transform offsets
			spawn_pos_parent.position += step.position_offset
			spawn_pos_parent.rotation_degrees += step.rotation_offset_degrees
			
			for spawn_cycle in range(0, step.spawn_cycles):
				
				for spawn_point in spawn_pos_parent.get_children():
					var new_projectile = step.projectile_scene.instantiate()
					get_tree().root.add_child(new_projectile)
					new_projectile.global_position = spawn_point.global_position
					new_projectile.rotation = spawn_point.global_rotation
				
				await get_tree().create_timer(step.spawn_delay).timeout
			
			
			
			await get_tree().create_timer(step.transition_delay).timeout
	
	running = false
	
