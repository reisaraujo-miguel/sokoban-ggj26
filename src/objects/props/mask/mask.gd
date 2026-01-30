extends Area2D

var cores: Dictionary = {
	"red mask": 0,
	"blue mask": 1,
	"yellow mask": 2,
	"green mask": 3,
	"no mask": 4,
}

@export var color: Game.MaskColor = Game.MaskColor.RED


func _ready() -> void:
	$Label.text = cores.find_key(color)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).equip_new_mask(color)
