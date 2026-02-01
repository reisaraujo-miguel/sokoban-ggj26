class_name Player
extends MovableObject2D

@export var equipped_mask: Game.MaskColor = Game.MaskColor.NO_COLOR

@onready var label: Label = $Label
@onready var aka = $Aka
@onready var ao = $Ao
@onready var kiiroi = $Kiiroi
@onready var midori = $Midori

func _ready() -> void:
	label.text = Game.Masks.find_key(equipped_mask)


func _physics_process(_delta: float) -> void:
	if current_state == State.IDLE:
		if Input.is_action_just_pressed("up") and can_move_to(Vector2.UP, RayUP):
			move_to(Vector2.UP)
		elif Input.is_action_just_pressed("down") and can_move_to(Vector2.DOWN, RayDown):
			move_to(Vector2.DOWN)
		elif Input.is_action_just_pressed("left") and can_move_to(Vector2.LEFT, RayLeft):
			move_to(Vector2.LEFT)
		elif Input.is_action_just_pressed("right") and can_move_to(Vector2.RIGHT, RayRight):
			move_to(Vector2.RIGHT)


func equip_new_mask(color: Game.MaskColor) -> void:
	equipped_mask = color
	label.text = Game.Masks.find_key(equipped_mask)
	aka.visible = false
	ao.visible = false
	kiiroi.visible = false
	midori.visible = false
	
	match equipped_mask:
		Game.MaskColor.RED:
			aka.visible = true
		Game.MaskColor.BLUE:
			ao.visible = true
		Game.MaskColor.YELLOW:
			kiiroi.visible = true
		Game.MaskColor.GREEN:
			midori.visible = true
		Game.MaskColor.NO_COLOR:
			pass
	

func can_move_to(direction: Vector2, ray: RayCast2D) -> bool:
	if not ray.is_colliding():
		return true
	elif ray.get_collider() is not PushableObject:
		fail_anim(direction)
		return false
	elif (ray.get_collider() as PushableObject).try_pushing(self, direction):
		return true
	else:
		fail_anim(direction)
		return false


func fail_anim(direction: Vector2) -> void:
	var tween: Tween = create_tween()

	current_state = State.MOVING

	var start_pos: Vector2 = position
	var max_pos: Vector2 = position + (direction * 5)

	@warning_ignore("return_value_discarded")
	tween.tween_property(self, "position", max_pos, MOVEMENT_DURATION / 4)

	@warning_ignore("return_value_discarded")
	tween.tween_property(self, "position", start_pos, MOVEMENT_DURATION / 4)

	@warning_ignore("return_value_discarded")
	tween.connect("finished", _set_state_idle)
