extends Line2D

@export var enabled: bool = true

@export var max_points: int = 20

@export var min_distance: float =  4


var parent_position: Vector2:
	get:
		return get_parent().position
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not enabled:
		return
		
	if points.size() == 0:
		_append_point()
	
	if _get_last_point().distance_to(parent_position) > min_distance:
		
		if points.size() < max_points:
			_append_point()
		else:
			
			# Remove first point
			points = points.slice(1, points.size())
			_append_point()

func _get_last_point():
	return points[points.size() - 1]

func _append_point():
	add_point(parent_position, points.size() + 1)
