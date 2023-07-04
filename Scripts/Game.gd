extends Node2D

@export var game_over_ui: CanvasLayer

@onready var game_timer = $GameTimer

var game_over: bool = false

signal game_started()
signal game_stopped()

func _ready():
	game_over_ui.hide()

func _process(delta):
	
	if game_over and Input.is_action_just_pressed("Attack"):
		get_tree().reload_current_scene()

func _on_player_died():
	game_over_ui.show()
	game_stopped.emit()
	
	# Don't accept input for a little after dying
	await get_tree().create_timer(1).timeout
	game_over = true

func _on_tutorial_completed():
	game_started.emit()
