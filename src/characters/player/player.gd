extends CharacterBody2D

const MOVEMENT_DISTANCE: float = 64.0
const MOVEMENT_DURATION: float = 0.5

enum State { IDLE, MOVING }

@onready var curr_state: State = State.IDLE


func _physics_process(_delta: float) -> void:
	if curr_state == State.IDLE:
		var direction: Vector2 = Vector2(
			Input.get_axis("ui_left", "ui_right"),
			Input.get_axis("ui_up", "ui_down"),
		)

		if direction.x:
			move_player(Vector2(direction.x, 0))
		elif direction.y:
			move_player(Vector2(0, direction.y))


func move_player(direction: Vector2) -> void:
	var tween: Tween = create_tween()

	curr_state = State.MOVING

	@warning_ignore("return_value_discarded")
	(
		tween.tween_property(self, "position", direction * MOVEMENT_DISTANCE, MOVEMENT_DURATION).as_relative().set_trans(Tween.TRANS_SINE)
	)

	@warning_ignore("return_value_discarded")
	tween.connect("finished", _set_state_idle)


func _set_state_idle() -> void:
	curr_state = State.IDLE
