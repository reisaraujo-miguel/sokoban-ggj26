extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	var fase_manager: FaseManager = get_tree().current_scene as FaseManager
	if fase_manager == null:
		push_error("FaseManager não encontrado na cena atual")
		return
	await get_tree().create_timer(0.5).timeout
	fase_manager.succes()
