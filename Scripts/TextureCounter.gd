extends Control

@export var texture: Texture2D

@onready var hbox: HBoxContainer = $HBoxContainer

func _on_health_changed(_max_health, health):
	
	if health == hbox.get_children().size():
		return
	
	for node in hbox.get_children():
		node.queue_free()
		
	for i in health:
		var new_graphic = TextureRect.new()
		
		new_graphic.texture = texture
		new_graphic.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		
		hbox.add_child(new_graphic)
		
	
