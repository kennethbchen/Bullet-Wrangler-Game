extends Resource

class_name ProjectileGeneratorStep

@export var position_offset: Vector2 = Vector2.ZERO
@export_range(0, 360, 0.1, "degrees") var rotation_offset_degrees: float = 0

@export var spawn_delay: float = 0.5
@export var transition_delay: float = 1

@export_range(0, 100, 1, "or_greater") var spawn_repeats: int = 1
@export_range(0, 100, 1, "or_greater") var step_repeats: int = 1
