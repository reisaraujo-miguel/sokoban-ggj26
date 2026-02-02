extends Control

func _ready():
	visible = true

func abrir():
	visible = true

func _on_btnfechar_pressed() -> void:
	visible = false
