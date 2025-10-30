extends CharacterBody3D

@onready var player: CharacterBody3D = %Player
@onready var column_left: Node3D = %PositionLeft
@onready var column_middle: Node3D = %PositionMiddle
@onready var column_right: Node3D = %PositionRight
@export var speed = 5

var jump_velocity = 5
var hop_velocity = 2
var gravity = 10

var current_position = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var input_vector = Vector3(
		input_direction.x,
		0.0,
		0.0,
	).normalized()
	
	#player.velocity.x = input_vector.x * speed
	
	move_and_slide()
	
	apply_gravity(delta)
	_jump()
	#_hop()
	move_columns(input_vector)
	
	#move_and_slide()
	
	pass

func apply_gravity(delta):
	if not is_on_floor():
		player.velocity.y -= gravity * delta

func _jump() -> void:
	if is_on_floor() and Input.is_action_pressed('jump'):
		player.velocity.y = jump_velocity
		
func _hop() -> void:
	if is_on_floor() and velocity.x != 0:
		player.velocity.y = hop_velocity
		
func move_columns(input_vector) -> void:
	if Input.is_action_just_pressed('ui_left'):
		current_position -= 1
		player.velocity.x = input_vector.x * speed
	elif Input.is_action_just_pressed('ui_right'):
		current_position += 1
		player.velocity.x = input_vector.x * speed
	if current_position < 0:
		current_position = 0
	elif current_position > 2:
		current_position = 2
	
	match current_position:
		0:
			#player.position.x = column_left.position.x
			smooth_move(column_left)
		1:
			#player.position.x = column_middle.position.x
			smooth_move(column_middle)
		2:
			#player.position.x = column_right.position.x
			smooth_move(column_right)

func smooth_move(column: Node3D) -> void:
	'''
	Make moving between columns look and feel smoother
	rather than just teleporting.
	'''
	_hop()
	if player.position.x < column.position.x + 0.05 and player.position.x > column.position.x - 0.05:
		player.velocity.x = 0
