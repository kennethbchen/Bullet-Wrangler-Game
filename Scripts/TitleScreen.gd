extends Node

signal tutorial_completed()

@onready var main_menu_canvas: CanvasLayer = $MainMenu
@onready var credits_canvas: CanvasLayer = $Credits

func _ready():
	main_menu_canvas.show()
	credits_canvas.hide()

func _on_test_projectile_area_entered(area: Area2D):
	tutorial_completed.emit()
	queue_free()

func _on_credits_area_entered(_area):
	main_menu_canvas.hide()
	credits_canvas.show()
	

func _on_credits_area_exited(_area):
	main_menu_canvas.show()
	credits_canvas.hide()
