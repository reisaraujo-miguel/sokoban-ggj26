extends Control

signal ResumeGame
signal ReloadLevel
signal QuitToLevelSelection
signal QuitToMainMenu

@onready var volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/VBoxContainer/VolumeSlider
@onready var master_bus_idx: int = AudioServer.get_bus_index(&"Master")


func _ready() -> void:
	volume_slider.value = AudioServer.get_bus_volume_linear(master_bus_idx)


func _on_resume_pressed() -> void:
	if emit_signal(&"ResumeGame") != OK:
		push_error("Error while emitting signal")


func _on_quit_pressed() -> void:
	if emit_signal(&"QuitToMainMenu") != OK:
		push_error("Error while emitting signal")


func _on_volume_slider_drag_ended(_value_changed: bool) -> void:
	AudioServer.set_bus_volume_linear(master_bus_idx, volume_slider.value)


func _on_reload_pressed() -> void:
	if emit_signal(&"ReloadLevel") != OK:
		push_error("Error while emitting signal")


func _on_level_selection_pressed() -> void:
	if emit_signal(&"QuitToLevelSelection") != OK:
		push_error("Error while emitting signal")
