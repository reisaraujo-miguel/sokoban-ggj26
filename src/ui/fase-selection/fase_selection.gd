extends Control

const fase_manager_node: PackedScene = preload("res://src/gerente_fase/gerente_fase.tscn")


func switch_to_fase(fase_number: int) -> void:
	var fase_manager: FaseManager = fase_manager_node.instantiate()
	fase_manager.numero_fase = fase_number
	if get_tree().change_scene_to_node(fase_manager) != OK:
		push_error("Error chaging scene to fase" + fase_manager.to_string())


func _on_fase_1_pressed() -> void:
	switch_to_fase(1)


func _on_fase_2_pressed() -> void:
	switch_to_fase(2)
