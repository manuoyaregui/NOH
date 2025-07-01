extends CanvasLayer

signal move_selected(move)

@onready var moves_container = $MovesPanel/MovesContainer
@onready var combat_log = $CombatLogPanel/CombatLog


func set_moves(moves: Array):
	for child in moves_container.get_children():
		moves_container.remove_child(child)
		child.queue_free()
	for move in moves:
		var btn = Button.new()
		btn.text = move.get_display_name()
		btn.pressed.connect(_on_move_button_pressed.bind(move))
		moves_container.add_child(btn)


func _on_move_button_pressed(move):
	emit_signal("move_selected", move)


func add_log_message(message: String):
	combat_log.append_text(message + "\n")
	combat_log.scroll_to_line(combat_log.get_line_count() - 1)
