extends CharacterBody3D

@onready var column_left: Node3D = %PositionLeft
@onready var column_middle: Node3D = %PositionMiddle
@onready var column_right: Node3D = %PositionRight

@onready var animation_player = get_node("CollisionShape3D/thumbThumb/AnimationPlayer")

@export var speed := 15
@export var invincibility_time: float = 2.0
@export var disabled_time: float = 2.0

@export var heart_overlay: PackedScene

var like_ready = false ## Whether the reel like is waiting for the next reel effect to double

var jump_velocity := 10
var hop_velocity := 2
var gravity := 30
var time_passed := 0
var current_position := 1


func _ready() -> void:
	Events.touched_interactable.connect(on_touched_interactable)

# Prevents player from liking one reel multiple times
func _process(delta: float) -> void:
	if Input.is_action_pressed('like_reel'):
		if not like_ready:
			like_ready = true
			Events.like_reel.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("like_reel"):
		add_child(heart_overlay.instantiate())

func _physics_process(delta: float) -> void:
	var input_direction := Vector2.ZERO

	if !GameState.stunned:
		input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		_jump()

	var input_vector := Vector3(input_direction.x, 0.0, 0.0).normalized()

	move_columns(input_vector)
	move_and_slide()
	apply_gravity(delta)

	time_passed += delta
	if delta >= 1:
		GameState.health -= 20
		time_passed = 0


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta


func _jump() -> void:
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_velocity
		animation_player.play("Jump")


func _hop() -> void:
	if is_on_floor() and velocity.x != 0:
		velocity.y = hop_velocity


func move_columns(input_vector) -> void:
	if Input.is_action_just_pressed("ui_left"):
		current_position -= 1
		velocity.x = input_vector.x * speed
		animation_player.play("DodgeLeft")

	elif Input.is_action_just_pressed("ui_right"):
		current_position += 1
		velocity.x = input_vector.x * speed
		animation_player.play("DodgeRight")

	if current_position < 0:
		current_position = 0
	elif current_position > 2:
		current_position = 2

	match current_position:
		0: smooth_move(column_left)
		1: smooth_move(column_middle)
		2: smooth_move(column_right)


func smooth_move(column: Node3D) -> void:
	# stop when close to target column
	if position.x < column.position.x + 0.15 and position.x > column.position.x - 0.15:
		velocity.x = 0
		rotation = Vector3.ZERO


func on_touched_interactable(interactable_name: String):
	var effect_multiplier = 2 if like_ready else 1

	match interactable_name:
		'coin':
			GameState.score += 100 * effect_multiplier
		'job_application':
			disable_controls(invincibility_time * effect_multiplier)
		'petr_sticker':
			GameState.score += 500 * effect_multiplier
		'please_shower':
			start_invincibility(invincibility_time * effect_multiplier)
			disable_controls(invincibility_time * effect_multiplier)
		'scooter':
			start_invincibility(invincibility_time * effect_multiplier)
		'six_seven':
			GameState.score -= 676 * effect_multiplier
			GameState.health -= 67 * effect_multiplier
		'tung_tung':
			GameState.score -= -500 * effect_multiplier
			GameState.health -= 500 * effect_multiplier

		like_ready = false # Allows player to like the next reel again


func start_invincibility(time: float = invincibility_time):
	if GameState.invincible:
		return

	GameState.invincible = true
	var timer := Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_end_invincibility"))
	add_child(timer)
	timer.start()


func _end_invincibility():
	GameState.invincible = false


func disable_controls(time: float = disabled_time):
	if GameState.stunned:
		return

	GameState.stunned = true
	var timer := Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_end_disabled"))
	add_child(timer)
	timer.start()


func _end_disabled():
	GameState.stunned = false
