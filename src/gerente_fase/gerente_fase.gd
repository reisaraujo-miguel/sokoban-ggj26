extends Node2D

class_name FaseManager

@export var numero_fase: int = 2
@export var objetivos_totais: int = 0
@export var objetivos_alcancado: int = 0

var checks_concluidos: Dictionary = { }
var tile_size: int = 64
var offset: int = 32

const mask_scene: PackedScene = preload("res://src/objects/props/mask/mask.tscn")
const pessoa: PackedScene = preload("res://src/objects/mobs/mob.tscn")
const checks: PackedScene = preload("res://src/objects/props/check/check.tscn")

const scene_map: Dictionary = {
	"J": { "scene": preload("res://src/objects/player/player.tscn") },
	"W": { "scene": preload("res://src/objects/props/wall/bloqueio.tscn") },
	"C": { "scene": preload("res://src/objects/props/caixa/caixa.tscn") },
	"MR": { "scene": mask_scene, "color": Game.MaskColor.RED },
	"MG": { "scene": mask_scene, "color": Game.MaskColor.GREEN },
	"MB": { "scene": mask_scene, "color": Game.MaskColor.BLUE },
	"MY": { "scene": mask_scene, "color": Game.MaskColor.YELLOW },
	"S": { "scene": preload("res://src/objects/props/saida/saida.tscn"), "saida": true },
	"PR": { "scene": pessoa, "mask_color": Game.MaskColor.RED },
	"PG": { "scene": pessoa, "mask_color": Game.MaskColor.GREEN },
	"PB": { "scene": pessoa, "mask_color": Game.MaskColor.BLUE },
	"PY": { "scene": pessoa, "mask_color": Game.MaskColor.YELLOW },
	"R": { "scene": checks, "space_color": Game.MaskColor.RED },
	"G": { "scene": checks, "space_color": Game.MaskColor.GREEN },
	"B": { "scene": checks, "space_color": Game.MaskColor.BLUE },
	"Y": { "scene": checks, "space_color": Game.MaskColor.YELLOW },
}

@onready var pause_menu: Control = $ui/PauseMenu
@onready var success_menu: Control = $ui/SuccessMenu
@onready var painel_mensagem: Control = $ui/PainelMensagem
@onready var txt: RichTextLabel = $ui/PainelMensagem/PanelCentro/MarginContainer/conteudo/texto


func _ready() -> void:
	load_level(numero_fase)


func succes() -> void:
	get_tree().paused = true
	success_menu.visible = true


func load_level(level_number: int) -> void:
	checks_concluidos.clear()
	objetivos_totais = 0
	objetivos_alcancado = 0

	var data: Dictionary = load_json("res://data/fases/fase" + str(level_number) + ".json")
	var dados: Variant = data.get("dados")

	if typeof(dados) != TYPE_DICTIONARY:
		push_error("Fase inválida: " + str(level_number))
		return

	clear_current_map()
	@warning_ignore("unsafe_call_argument")
	spawn_from_map(dados)
	txt.text = data.get("descricao")
	painel_mensagem.visible = true


func load_next() -> void:
	numero_fase += 1
	load_level(numero_fase)


func clear_current_map() -> void:
	for child: Node in get_children():
		if child is CanvasLayer or child is TileMapLayer:
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
	var min_pos: Vector2 = Vector2(INF, INF)
	var max_pos: Vector2 = Vector2(-INF, -INF)
	var player: Player
	for key: String in data.keys():
		if not scene_map.has(key):
			push_warning("Sem scene mapeada para: " + key)
			continue

		var config: Dictionary = scene_map[key]
		var scene: PackedScene = config["scene"]

		for grid_pos: Array in data[key]:
			var node: Node2D = scene.instantiate()
			node.position = grid_to_world(grid_pos)

			if node is Player:
				player = node
			if config.has("color"):
				@warning_ignore("unsafe_property_access")
				node.color = config["color"]
			if config.has("mask_color"):
				(node as PushableObject).object_color = config["mask_color"]
			if config.has("space_color"):
				(node as Check).object_color = config["space_color"]
				if node is Check:
					objetivos_totais += 1
					if (node as Check).objetivo_ativado.connect(_on_check_ativado) != OK:
						push_error("error connecting signal")
					if (node as Check).objetivo_desativado.connect(_on_check_desativado) != OK:
						push_error("error connecting signal")

			min_pos.x = min(min_pos.x, node.position.x)
			min_pos.y = min(min_pos.y, node.position.y)
			max_pos.x = max(max_pos.x, node.position.x)
			max_pos.y = max(max_pos.y, node.position.y)

			call_deferred("add_child", node)
	player.min_pos = min_pos
	player.max_pos = max_pos


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


func change_to_scene_path(path: String) -> void:
	var packed_scene: PackedScene = load(path)
	get_tree().paused = false
	if get_tree().change_scene_to_packed(packed_scene) != OK:
		push_error("error changing scene")


func _on_pause_menu_resume_game() -> void:
	pause_menu.visible = false
	get_tree().paused = false


func _on_pause_menu_quit_to_main_menu() -> void:
	change_to_scene_path("res://src/ui/start-menu/start-menu.tscn")


func _on_pause_menu_reload_level() -> void:
	load_level(numero_fase)
	pause_menu.visible = false
	get_tree().paused = false


func _on_pause_menu_quit_to_level_selection() -> void:
	change_to_scene_path("res://src/ui/fase-selection/fase_selection.tscn")


func _on_success_menu_goto_level_selection() -> void:
	change_to_scene_path("res://src/ui/fase-selection/fase_selection.tscn")


func _on_success_menu_goto_next_level() -> void:
	if FileAccess.file_exists("res://data/fases/fase" + str(numero_fase + 1) + ".json"):
		get_tree().paused = false
		success_menu.visible = false
		load_next()
	else:
		change_to_scene_path("res://src/ui/fase-selection/fase_selection.tscn")


func _on_success_menu_reload_level() -> void:
	load_level(numero_fase)
	success_menu.visible = false
	get_tree().paused = false


func _on_check_ativado(check: Check) -> void:
	checks_concluidos[check] = true
	objetivos_alcancado = checks_concluidos.size()

	if objetivos_alcancado == objetivos_totais:
		await get_tree().create_timer(1.0).timeout
		if objetivos_alcancado == objetivos_totais:
			succes()


func _on_check_desativado(check: Check) -> void:
	@warning_ignore("return_value_discarded")
	checks_concluidos.erase(check)
	objetivos_alcancado = checks_concluidos.size()
