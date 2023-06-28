extends Area2D

@export var speed = 20

var forward_dir = transform.x

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position += forward_dir * speed * delta
