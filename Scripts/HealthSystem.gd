extends Node

class_name HealthSystem

@export var max_health: int = 3

var health: int = max_health

signal health_changed(max_health, health)
signal health_zeroed

func _ready():
	health = max_health

func change_health(delta: int):
	
	if delta == 0: return
	
	health = max(0, min(max_health, health + delta))
	
	health_changed.emit(max_health, health)
	
	if health == 0:
		health_zeroed.emit()
		
	
