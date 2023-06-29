extends Resource

class_name ProjectileGeneratorStep

@export var skip: bool = false
@export_group("Nodes")

# Exporting NodePath instead of Node2D is a workaround because 
# this resource is loaded before the spawn_positions, meaning they are incorrectly null at runtime
@export var spawn_position_parent_path: NodePath
@export var projectile_scene: PackedScene

@export_group("Transform Offset")
@export var position_offset: Vector2 = Vector2.ZERO
@export_range(-360.0, 360.0, 0.1, "degrees") var rotation_offset_degrees: float = 0

@export_group("Delay Parameters")
@export var spawn_delay: float = 0
@export var transition_delay: float = 1

@export_group("Repeat Parameters")
@export_range(1, 100, 1, "or_greater") var spawn_cycles: int = 1
@export_range(1, 100, 1, "or_greater") var step_cycles: int = 1

func _ready():
	assert(spawn_position_parent_path is NodePath)
	assert(projectile_scene != null)
	
