extends Resource

class_name SoundEffect

@export var name: String

@export var audio_clips: Array[AudioStream]

func _ready():
	print("ey")
	assert(not name.is_empty())
