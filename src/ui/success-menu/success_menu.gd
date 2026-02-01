extends Control

signal GotoNextLevel
signal ReloadLevel
signal GotoLevelSelection


func _on_next_level_pressed() -> void:
	if emit_signal(&"GotoNextLevel") != OK:
		push_error("erro emitting signal")


func _on_reload_pressed() -> void:
	if emit_signal(&"ReloadLevel") != OK:
		push_error("erro emitting signal")


func _on_level_selection_pressed() -> void:
	if emit_signal(&"GotoLevelSelection") != OK:
		push_error("erro emitting signal")
