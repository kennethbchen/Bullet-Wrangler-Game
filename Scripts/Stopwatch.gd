extends Node

class_name Stopwatch

var start_time: float = -1

var stop_time: float = -1

func start():
	start_time = Time.get_ticks_msec()
	stop_time = -1

func stop():
	stop_time = Time.get_ticks_msec()

func get_elapsed_seconds():
	
	var end_time: float
	if stop_time == -1:
		end_time = Time.get_ticks_msec()
	else:
		end_time = stop_time
		
	
	return (end_time - start_time) / 1000

func _on_game_start():
	start()
	
func _on_game_stop():
	stop()
