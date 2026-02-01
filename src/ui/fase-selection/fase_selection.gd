extends Control

const FASE_MANAGER_SCENE: PackedScene = preload("res://src/gerente_fase/gerente_fase.tscn")


func switch_to_fase(fase_number: int) -> void:
	var fase_manager: FaseManager = FASE_MANAGER_SCENE.instantiate() as FaseManager
	fase_manager.numero_fase = fase_number

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(fase_manager)
	get_tree().current_scene = fase_manager


func _on_fase_1_pressed() -> void:
	switch_to_fase(1)


func _on_fase_2_pressed() -> void:
	switch_to_fase(2)


func _on_button_pressed() -> void:
	var packed_scene: PackedScene = load("res://src/ui/start-menu/start-menu.tscn")
	if get_tree().change_scene_to_packed(packed_scene) != OK:
		push_error("error changing scene")
