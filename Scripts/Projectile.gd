extends Area2D

@export var speed = 20

@export var lifespan = 5

@onready var lifetime_timer = $LifetimeTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	lifetime_timer.wait_time = lifespan
	lifetime_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position += transform.x * speed * delta
