extends Control

@export var menu_music: AudioStreamMP3
@export var run_music: AudioStreamMP3
@export var run_music_node: AudioStreamPlayer
@export var menu_music_node: AudioStreamPlayer

@export var transition_timer: Timer

func toggle_pause():
	get_tree().paused = not get_tree().paused
	_transition()
	visible = not visible
	
func _transition():
	# Does the volume transition
	var x = 0
	while x < 1:
		x += transition_timer.wait_time
		_transition_function(x)
		transition_timer.start()
		print(run_music_node.volume_linear)
	
	
	
func _transition_function(x: float):
	# Calculates the current volume for the transition at time x
	run_music_node.stream_paused = false
	menu_music_node.stream_paused = false
	if x <= 0.5:
		run_music_node.volume_linear = _volume_function(x)
	elif x <= 1:
		menu_music_node.volume_linear = _volume_function(x)
		
	if x >= 1:
		run_music_node.stream_paused = true
		run_music_node.volume_linear = 1.0
		menu_music_node.stream_paused = true
		menu_music_node.volume_linear = 1.0
	
func _volume_function(x: float): # Used to determine volume in transition
	return pow(cos(PI*x), 2)
	
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
