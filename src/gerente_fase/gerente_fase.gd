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

func _ready() -> void:
	var data: = load_json("res://data/fases/fase" + str(numero_fase) + ".json")
	spawn_from_map(data["dados"])

func load_next() -> void:
	numero_fase += 1
	clear_current_map()
	var data := load_json("res://data/fases/fase" + str(numero_fase) + ".json")
	spawn_from_map(data["dados"])

func clear_current_map() -> void:
	for child in get_children():
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

func spawn_from_map(data) -> void:
	for key in data.keys():
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

			add_child(node)

func grid_to_world(grid_pos: Array) -> Vector2:
	@warning_ignore("unsafe_call_argument")
	return Vector2(
		grid_pos[1] * tile_size + offset,
		grid_pos[0] * tile_size + offset,
	)
