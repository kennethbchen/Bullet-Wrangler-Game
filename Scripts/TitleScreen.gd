extends Node

signal tutorial_completed()

func _on_test_projectile_area_entered(area: Area2D):
	tutorial_completed.emit()
	queue_free()
