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

var is_invincible: bool = false
@export var invincibility_time: float = 2.0  # seconds

var controls_disabled: bool = false
@export var disabled_time: float = 2.0

@onready var animation_player = get_node("CollisionShape3D/thumbThumb/AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.touched_interactable.connect(on_touched_interactable)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Vector2.ZERO
	if !controls_disabled:
		input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		_jump()
		
	var input_vector = Vector3(
		input_direction.x,
		0.0,
		0.0,
	).normalized()

	move_columns(input_vector)
	
	move_and_slide()
	
	apply_gravity(delta)
	
	
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
		animation_player.play('Jump')
func _hop() -> void:
	if is_on_floor() and velocity.x != 0:
		velocity.y = hop_velocity
		
func move_columns(input_vector) -> void:
	if Input.is_action_just_pressed('ui_left'):
		current_position -= 1
		velocity.x = input_vector.x * speed
		animation_player.play('DodgeLeft')
	elif Input.is_action_just_pressed('ui_right'):
		current_position += 1
		velocity.x = input_vector.x * speed
		animation_player.play('DodgeRight')
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

func on_touched_interactable(interactable_name: String):
	if interactable_name == "coin" or interactable_name=='scooter' or interactable_name=='petr_sticker':
		print("coin collected") # idk the name of the coin collected signal but that would go here
	else: # damage might be based on another signal but this is the damage amount
		Events.set_player_health.emit(health - 10/3)
		health -= 10/3
		if health <= 0:
			Events.game_over.emit()
	pass

func start_invincibility(time: float = invincibility_time):
	if is_invincible:
		return  # Already invincible, ignore
	is_invincible = true

	# Timer to end invincibility
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_end_invincibility"))
	add_child(timer)
	timer.start()

func _end_invincibility():
	is_invincible = false
	
func disable_controls(time: float = disabled_time):
	if controls_disabled:
		return  # Already invincible, ignore
	controls_disabled = true

	# Timer to end invincibility
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_end_disabled"))
	add_child(timer)
	timer.start()
	

func _end_disabled():
	controls_disabled = false
	
