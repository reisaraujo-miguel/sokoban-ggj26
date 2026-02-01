extends Node2D

class_name FaseManager

@export var numero_fase: int = 1

var tile_size: int = 64
var offset: int = 32

const mask_scene: PackedScene = preload("res://src/objects/props/mask/mask.tscn")

const scene_map: Dictionary = {
	"J": { "scene": preload("res://src/objects/player/player.tscn") },
	"W": { "scene": preload("res://src/objects/props/wall/bloqueio.tscn") },
	"C": { "scene": preload("res://src/objects/props/caixa/caixa.tscn") },
	"MR": { "scene": mask_scene, "color": Game.MaskColor.RED },
	"MG": { "scene": mask_scene, "color": Game.MaskColor.GREEN },
	"MB": { "scene": mask_scene, "color": Game.MaskColor.BLUE },
	"MY": { "scene": mask_scene, "color": Game.MaskColor.YELLOW },
	"S": { "scene": preload("res://src/objects/props/saida/saida.tscn"), "saida": true },
}

@onready var pause_menu: Control = $ui/PauseMenu


func _ready() -> void:
	load_level(numero_fase)


func load_level(level_number: int) -> void:
	var data: Dictionary = load_json("res://data/fases/fase" + str(level_number) + ".json")
	var dados: Variant = data.get("dados")

	if typeof(dados) != TYPE_DICTIONARY:
		push_error("Fase inválida: " + str(level_number))
		return

	clear_current_map()
	@warning_ignore("unsafe_call_argument")
	spawn_from_map(dados)


func load_next() -> void:
	numero_fase += 1
	load_level(numero_fase)


func clear_current_map() -> void:
	for child: Node in get_children():
		if child is CanvasLayer:
			continue
		child.queue_free()


func load_json(path: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Não foi possível abrir: " + path)
		return { }
	var content: String = file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(content)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("JSON inválido: " + path)
		return { }
	return parsed


func spawn_from_map(data: Dictionary) -> void:
	for key: String in data.keys():
		if not scene_map.has(key):
			push_warning("Sem scene mapeada para: " + key)
			continue

		var config: Dictionary = scene_map[key]
		var scene: PackedScene = config["scene"]

		for grid_pos: Array in data[key]:
			var node: Node2D = scene.instantiate()
			node.position = grid_to_world(grid_pos)

			if config.has("color"):
				@warning_ignore("unsafe_property_access")
				node.color = config["color"]

			call_deferred("add_child", node)


func grid_to_world(grid_pos: Array) -> Vector2:
	@warning_ignore("unsafe_call_argument")
	return Vector2(
		grid_pos[1] * tile_size + offset,
		grid_pos[0] * tile_size + offset,
	)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		pause_menu.visible = true
		get_tree().paused = true


func _on_pause_menu_resume_game() -> void:
	pause_menu.visible = false
	get_tree().paused = false


func _on_pause_menu_quit_to_main_menu() -> void:
	var main_menu_scene: PackedScene = load("res://src/ui/start-menu/start-menu.tscn")
	get_tree().paused = false
	if get_tree().change_scene_to_packed(main_menu_scene) != OK:
		push_error("error changing scene")


func _on_pause_menu_reload_level() -> void:
	load_level(numero_fase)
	pause_menu.visible = false
	get_tree().paused = false


func _on_pause_menu_quit_to_level_selection() -> void:
	var level_selection_scene: PackedScene = load("res://src/ui/fase-selection/fase_selection.tscn")
	get_tree().paused = false
	if get_tree().change_scene_to_packed(level_selection_scene) != OK:
		push_error("error changing scene")
