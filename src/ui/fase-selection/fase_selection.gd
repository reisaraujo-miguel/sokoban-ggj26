extends Control

const FASE_MANAGER_SCENE: PackedScene = preload("res://src/gerente_fase/gerente_fase.tscn")
const FASE_BTN_SCENE: PackedScene = preload("res://src/ui/fase-selection/fase_btn.tscn")
@onready var grid: GridContainer = $MarginContainer/VBoxContainer/GridContainer

func _ready() -> void:
	var i: int = 1
	while FileAccess.file_exists("res://data/fases/fase" + str(i) + ".json"):
		var fase_btn = FASE_BTN_SCENE.instantiate()
		var label: Label = fase_btn.get_node("Label")
		label.text = "Fase " + str(i)

		if fase_btn is TextureButton:
			fase_btn.pressed.connect(switch_to_fase.bind(i))

		grid.add_child(fase_btn)
		i += 1

func switch_to_fase(fase_number: int) -> void:
	var fase_manager: FaseManager = FASE_MANAGER_SCENE.instantiate() as FaseManager
	fase_manager.numero_fase = fase_number

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(fase_manager)
	get_tree().current_scene = fase_manager


func _on_button_pressed() -> void:
	var packed_scene: PackedScene = load("res://src/ui/start-menu/start-menu.tscn")
	if get_tree().change_scene_to_packed(packed_scene) != OK:
		push_error("error changing scene")
