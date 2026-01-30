extends Control

const fase_selection: PackedScene = preload("res://src/ui/fase-selection/fase_selection.tscn")


func _on_exit_btn_pressed() -> void:
	get_tree().quit()


func _on_play_btn_pressed() -> void:
	if get_tree().change_scene_to_packed(fase_selection) != OK:
		push_error("Error changing scene to fase selection scene")
