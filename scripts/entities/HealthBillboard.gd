extends Label3D


func set_health(current: int, max: int):
	text = "HP: %d / %d" % [current, max]
