extends CharacterBody3D

@onready var column_left: Node3D = %PositionLeft
@onready var column_middle: Node3D = %PositionMiddle
@onready var column_right: Node3D = %PositionRight
@export var speed = 15

var jump_velocity = 10
var hop_velocity = 2
var gravity = 30
var health = 100
var time_passed = 0

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
	
	move_and_slide()
	
	apply_gravity(delta)
	_jump()
	move_columns(input_vector)
	
	time_passed += delta
	if delta >= 1: # every second your algo score decreases a bit
		Events.set_player_health.emit(health - 5/300)
		time_passed = 0
	
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
		rotate_y(35)
	elif Input.is_action_just_pressed('ui_right'):
		current_position += 1
		velocity.x = input_vector.x * speed
		rotate_y(-35)
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
	# _hop()
	if position.x < column.position.x + 0.15 and position.x > column.position.x - 0.15:
		velocity.x = 0
		rotation = Vector3(0,0,0)

func _on_area_3d_area_entered(body: Node3D) -> void:
	if body.name == "CoinArea":
		print("coin collected") # idk the name of the coin collected signal but that would go here
	else: # damage might be based on another signal but this is the damage amount
		Events.set_player_health.emit(health - 10/3)
		health -= 10/3
		if health <= 0:
			print("WOOWW YOU DIEDDD") # replace with death signal
