extends Node2D

@export var game_over_ui: CanvasLayer

@onready var game_timer = $GameTimer

var game_over: bool = false

signal game_started()
signal game_stopped()

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_ui.hide()

	game_started.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if game_over and Input.is_action_just_pressed("Attack"):
		get_tree().reload_current_scene()

func _on_player_died():
	game_over_ui.show()
	game_over = true
	game_stopped.emit()
