extends Control

const FASE_SELECTION: PackedScene = preload("res://src/ui/fase-selection/fase_selection.tscn")
const CREDITOS_SCENE: PackedScene = preload("res://src/ui/creditos-menu/creditos-menu.tscn")


func _on_exit_btn_pressed() -> void:
	get_tree().quit()


func _on_creditos_btn_pressed() -> void:
	if get_tree().change_scene_to_packed(CREDITOS_SCENE) != OK:
		push_error("Error changing scene to creditos scene")


func _on_play_btn_pressed() -> void:
	if get_tree().change_scene_to_packed(FASE_SELECTION) != OK:
		push_error("Error changing scene to fase selection scene")
