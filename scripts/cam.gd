extends Camera2D

@export var movement_speed := 4.0

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#zoom.x += 0.1
			#zoom.y += 0.1

func _process(delta: float) -> void:
	var inp = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	offset += inp * movement_speed
