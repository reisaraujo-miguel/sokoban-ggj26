extends Area2D

@export var numero_fase: int

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	var fase_manager := get_tree().current_scene as FaseManager
	if fase_manager == null:
		push_error("FaseManager não encontrado na cena atual")
		return
	fase_manager.load_next()
