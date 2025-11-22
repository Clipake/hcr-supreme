extends Control

@export var menu_music: AudioStreamMP3
@export var run_music: AudioStreamMP3
@export var run_music_node: AudioStreamPlayer
@export var menu_music_node: AudioStreamPlayer

@export var transition_timer: Timer

var x = 0 ## Transition variable for managing switch from run to menu music
var backwards = false ## Determines transition direction

func _ready() -> void:
	Events.game_over.connect(func():
		queue_free()
	)

func toggle_pause():
	get_tree().paused = not get_tree().paused
	transition_timer.start()
	backwards = get_tree().paused
	visible = not visible
	
func _transition():
	# Does the volume transition
	x += transition_timer.wait_time if backwards else -transition_timer.wait_time
	x = clamp(x, 0, 1)
	_transition_function(x)
	if 0 < x and x < 1:
		transition_timer.start()
	
func _transition_function(x: float):
	# Calculates the current volume for the transition at progress x (0-1)
	run_music_node.stream_paused = false
	menu_music_node.stream_paused = false
	if x <= 0: # Fully transitioned to run
		run_music_node.stream_paused = false
		menu_music_node.stream_paused = true
	elif x >= 1: # Fully transitioned to menu
		run_music_node.stream_paused = true
		menu_music_node.stream_paused = false
	else: # In the middle of transitioning
		run_music_node.volume_linear = _run_volume_transition(x)
		menu_music_node.volume_linear = _menu_volume_transition(x)
	
func _run_volume_transition(x: float): # Used to determine run music volume in transition
	return pow(cos(0.5*PI*x), 2)
	
func _menu_volume_transition(x: float): # Used to determine menu music  volume in transition
	return pow(sin(0.5*PI*x), 2)
	
func _process(delta):
	if Input.is_action_just_pressed('game_pause'):
		toggle_pause()

func _on_resume_pressed():
	toggle_pause()

func _on_restart_pressed():
	Events.restart_game.emit()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	Events.open_home.emit()
