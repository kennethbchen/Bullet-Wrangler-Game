extends Line2D

@export var enabled: bool = true

@export var tracked_node: Node2D

@export var max_points: int = 20

@export var min_distance: float =  4

@export var min_loop_point_count: int = 5


var tracked_position: Vector2:
	get:
		return tracked_node.position

var first_point: Vector2:
	get:
		return points[0]

var last_point: Vector2:
	get:
		return points[points.size() - 1]
		
signal loop_created(line_drawer, points)

func _ready():
	assert(tracked_node is Node2D)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not enabled:
		return
	
	
	if points.size() == 0:
		_append_point()
	
	# Try to add new points to the line
	if last_point.distance_to(tracked_position) > min_distance:
		
		if points.size() < max_points:
			_append_point()
		else:
			
			# Remove first point
			points = points.slice(1, points.size())
			_append_point()
			
	if _is_loop():
		loop_created.emit(self, points)


func _append_point():
	add_point(tracked_position, points.size() + 1)

func _is_loop():
	return points.size() > min_loop_point_count and \
		first_point.distance_to(last_point) < min_distance + 2
		
