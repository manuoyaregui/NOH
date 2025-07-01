extends Label3D


func set_health(current_value: int, max_value: int):
	text = "HP: %d / %d" % [current_value, max_value]
