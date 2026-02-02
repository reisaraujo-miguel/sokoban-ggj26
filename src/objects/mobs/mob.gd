extends PushableObject

@onready var Pb:Sprite2D = $Pb
@onready var Pg:Sprite2D = $Pg
@onready var Pr:Sprite2D = $Pr
@onready var Py:Sprite2D = $Py

func _ready() -> void:
	Pb.visible = false
	Pg.visible = false
	Pr.visible = false
	Py.visible = false
	
	match object_color:
		Game.MaskColor.RED:
			Pr.visible = true
		Game.MaskColor.BLUE:
			Pb.visible = true
		Game.MaskColor.YELLOW:
			Py.visible = true
		Game.MaskColor.GREEN:
			Pg.visible = true
		Game.MaskColor.NO_COLOR:
			pass
