extends Node

@export var run_forever = false

@export var steps: Array[ProjectileGeneratorStep]

@onready var projectile_owner: Node2D

@onready var sfx_controller: SoundEffectController = $SoundEffectController

# I'm lazy
@onready var projectile_parent: Node = $"/root/Game/AttackParent"

var running : bool = false

func _ready():
	projectile_owner = get_parent()
	
	for step in steps:
		
		if step.sound_effect != null:
			sfx_controller.add_sfx(step.sound_effect)


func _process(delta):
	
	if run_forever and not running:
		start()

func start():
	
	if running: return
	
	running = true
	for step in steps:
		
		if step.skip:
			continue
		
		var spawn_pos_parent = get_node(step.spawn_position_parent_path)
		
		var rotation_inherit_source: Node2D = get_node_or_null(step.aim_rotation_source_path)
		
		for step_cycle in range(0, step.step_cycles):
			
			# Inherit rotation if needed
			if rotation_inherit_source != null and \
						step.aim_type == step.AIM_TYPE.PER_STEP:
				spawn_pos_parent.rotation_degrees = rotation_inherit_source.rotation_degrees
			
			# Play Sound Effect if needed
			if step.sound_effect != null and step.sound_type == step.SFX_TYPE.PER_STEP:
				sfx_controller.play_random(step.sound_effect.name)
			
			for spawn_cycle in range(0, step.spawn_cycles):
				
				# Inherit rotation if needed
				if rotation_inherit_source != null and \
						step.aim_type == step.AIM_TYPE.PER_SPAWN:
					spawn_pos_parent.rotation_degrees = rotation_inherit_source.rotation_degrees
				
				# Play Sound Effect if needed
				if step.sound_effect != null and step.sound_type == step.SFX_TYPE.PER_SPAWN:
					sfx_controller.play_random(step.sound_effect.name)
				
				for spawn_point in spawn_pos_parent.get_children():

					var new_projectile = step.projectile_scene.instantiate()
					projectile_parent.add_child(new_projectile)
					new_projectile.global_position = spawn_point.global_position
					new_projectile.rotation = spawn_point.global_rotation
					new_projectile.init(projectile_owner)
				
				await get_tree().create_timer(step.spawn_delay).timeout
			
			# Apply transform offsets
			spawn_pos_parent.position += step.position_offset
			spawn_pos_parent.rotation_degrees += step.rotation_offset_degrees
			
			await get_tree().create_timer(step.transition_delay).timeout
	
	running = false
	
