extends Node3D

@onready var timer = $DashTimer

func start_dash()->void:
	#timer.wait_time = 0.1
	timer.start()
	
func is_dashing():
	return !timer.is_stopped()
	
