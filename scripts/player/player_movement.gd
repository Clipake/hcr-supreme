extends CharacterBody3D

@onready var column_left: Node3D = %PositionLeft
@onready var column_middle: Node3D = %PositionMiddle
@onready var column_right: Node3D = %PositionRight
@export var speed = 7
@export var heart_overlay: PackedScene

var jump_velocity = 5
var hop_velocity = 2
var gravity = 10

var current_position = 1

var like_ready = false ## Whether the reel like is waiting for the next reel effect to double

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.reel_effect_trigger.connect(_reel_effect_trigger)


# Creates a like heart overlay everytime the user attempts to like a reel (even if already liked)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("like_reel"):
		add_child(heart_overlay.instantiate())


# Prevents player from liking one reel multiple times
func _process(delta: float) -> void:
	if Input.is_action_pressed('like_reel'):
		if not like_ready:
			like_ready = true
			Events.like_reel.emit()


func _reel_effect_trigger():
	like_ready = false # Allows player to like the next reel again
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_vector = Vector3(
		input_direction.x,
		0.0,
		0.0,
	).normalized()
	
	move_and_slide()
	
	apply_gravity(delta)
	_jump()
	move_columns(input_vector)
	
	pass

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func _jump() -> void:
	if is_on_floor() and Input.is_action_pressed('jump'):
		velocity.y = jump_velocity
		
func _hop() -> void:
	if is_on_floor() and velocity.x != 0:
		velocity.y = hop_velocity
		
func move_columns(input_vector) -> void:
	if Input.is_action_just_pressed('ui_left'):
		current_position -= 1
		velocity.x = input_vector.x * speed
	elif Input.is_action_just_pressed('ui_right'):
		current_position += 1
		velocity.x = input_vector.x * speed
	if current_position < 0:
		current_position = 0
	elif current_position > 2:
		current_position = 2
	
	match current_position:
		0:
			smooth_move(column_left)
		1:
			smooth_move(column_middle)
		2:
			smooth_move(column_right)

func smooth_move(column: Node3D) -> void:
	'''
	Make moving between columns look and feel smoother
	rather than just teleporting.
	'''
	_hop()
	if position.x < column.position.x + 0.05 and position.x > column.position.x - 0.05:
		velocity.x = 0
