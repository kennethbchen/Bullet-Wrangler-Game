extends Node

@export_category("Nodes")
@export var game_timer: Stopwatch
@export var enemy_scene: PackedScene
@export var enemy_target: Node2D

@export_category("Spawn Parameters")
@export var enemy_spawn_delay: float = 15
@export_range(1, 2, 1, "or_greater") var max_enemies: int = 1

@onready var enemy_parent: Node = $Enemies
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var patrol_points_parent: Node = $PatrolPoints



# Called when the node enters the scene tree for the first time.
func _ready():
	assert(game_timer is Stopwatch)
	assert(enemy_scene is PackedScene)
	assert(enemy_target is Node2D)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if get_num_enemies() < max_enemies:
		
		var new_enemy = enemy_scene.instantiate() as Enemy
		enemy_parent.add_child(new_enemy)
		
		new_enemy.init(patrol_points_parent, enemy_target)
		new_enemy.global_position = spawn_point.global_position


	

func get_num_enemies() -> int:
	return enemy_parent.get_child_count()
