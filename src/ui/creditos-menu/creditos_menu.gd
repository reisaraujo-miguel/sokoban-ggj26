extends Control

func _on_button_pressed() -> void:
	var packed_scene: PackedScene = load("res://src/ui/start-menu/start-menu.tscn")
	if get_tree().change_scene_to_packed(packed_scene) != OK:
		push_error("error changing scene")
