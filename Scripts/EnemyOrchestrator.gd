extends Node

@export_category("Nodes")
@export var game_timer: Stopwatch
@export var enemy_scene: PackedScene
@export var enemy_target: Node2D

@export_category("Spawn Parameters")
@export var enemy_spawn_delay: float = 20
@export_range(1, 2, 1, "or_greater") var max_enemies: int = 1

@onready var spawn_timer: Timer = $SpawnTimer

@onready var enemy_parent: Node = $Enemies
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var patrol_points_parent: Node = $PatrolPoints

var num_enemies = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(game_timer is Stopwatch)
	assert(enemy_scene is PackedScene)
	assert(enemy_target is Node2D)

func should_spawn_enemy():
	return num_enemies < max_enemies

func _create_enemy() -> void:
	
	num_enemies += 1
	
	var new_enemy = enemy_scene.instantiate() as Enemy
	
	enemy_parent.add_child(new_enemy)
	
	new_enemy.init(patrol_points_parent, enemy_target)
	new_enemy.global_position = spawn_point.global_position
	new_enemy.died.connect(_on_enemy_died)

func _on_spawn_timer_timeout():
	
	if should_spawn_enemy():
		_create_enemy()
	
	spawn_timer.wait_time = enemy_spawn_delay
	spawn_timer.start()

func _on_enemy_died():
	
	num_enemies -= 1
	if num_enemies == 0:
		await get_tree().create_timer(0.75).timeout
		call_deferred("_create_enemy")
		spawn_timer.start()

func _on_game_start():
	
	_on_spawn_timer_timeout()
	
	spawn_timer.wait_time = enemy_spawn_delay
	spawn_timer.start()
	
func _on_game_stop():
	spawn_timer.stop()
