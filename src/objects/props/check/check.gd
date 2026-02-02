extends Area2D
class_name Check

signal objetivo_ativado(check: Check)
signal objetivo_desativado(check: Check)

@export var object_color: Game.MaskColor = Game.MaskColor.NO_COLOR

var ativo := false
var ocupante: PushableObject = null

@onready var B: Sprite2D = $B
@onready var G: Sprite2D = $G
@onready var R: Sprite2D = $R
@onready var Y: Sprite2D = $Y

func _ready() -> void:
	match object_color:
		Game.MaskColor.RED:
			R.visible = true
		Game.MaskColor.BLUE:
			B.visible = true
		Game.MaskColor.YELLOW:
			Y.visible = true
		Game.MaskColor.GREEN:
			G.visible = true
		Game.MaskColor.NO_COLOR:
			pass

func _on_body_entered(body: Node2D) -> void:
	if body is not PushableObject:
		return

	if body.object_color != object_color:
		return

	ocupante = body
	ativo = true
	emit_signal("objetivo_ativado", self)

func _on_body_exited(body: Node2D) -> void:
	if body != ocupante:
		return

	ocupante = null
	ativo = false
	emit_signal("objetivo_desativado", self)
