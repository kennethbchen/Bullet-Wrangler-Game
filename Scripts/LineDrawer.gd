extends Line2D

@export var enabled: bool = true

@export var tracked_node: Node2D

@export var max_points: int = 25

@export var min_distance: float =  6

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
			
		# Points changed, check for intersection
		if _is_loop():
			loop_created.emit(self, points)


func _append_point():
	add_point(tracked_position, points.size() + 1)

func _is_loop():
	
	if points.size() < min_loop_point_count:
		return false
	
	# Loop Check 2: Check for if the first point is close to the last point
	# This is nice if you're trying to close the loop by joining the edges together
	if points.size() > min_loop_point_count and \
		first_point.distance_to(last_point) < min_distance + 2:
			
			# Close the loop nicely
			points[points.size() - 1] = points[0]
			
			return true
			
	# Loop Check 2: Brute force compare every segement with every other
	# and see if there are any intersections
	var intersect_point = null
	for i in range(0, points.size() - 1):
		
		var a_from = points[i]
		var a_to = points[i+1]
		
		# Start at i + 2 because segements with [index < i] have already been checked
		# and j = i / j = i + 1 would be skipped because they share points
		for j in range(i + 2, points.size() - 1):
			
			var b_from = points[j]
			var b_to = points[j+1]
			
			# Don't compare segments if they share points
			if b_from == a_from or b_from == a_to or \
				b_to == a_from or b_to == a_to:
					continue
			
			intersect_point = Geometry2D.segment_intersects_segment(a_from, a_to, b_from, b_to)
			
			if intersect_point != null:
				
				# We need to fix this line so that it's not self intersecting
				# Because j > i, that means that the range (i, j + 1) is the main loop
				# are are probably also guarenteed to not be intersecting
				
				points = points.slice(i, j)
				
				# Close the loop nicely by making the first and last points the same
				points[0] = intersect_point
				points[points.size() - 1] = intersect_point
				
				return true

	return false
