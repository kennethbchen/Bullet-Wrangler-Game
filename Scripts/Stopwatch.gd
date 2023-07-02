extends Node

class_name Stopwatch

var start_time: float = -1

func start():
	start_time = Time.get_ticks_msec()

func get_elapsed_seconds():
	return (Time.get_ticks_msec() - start_time) / 1000
