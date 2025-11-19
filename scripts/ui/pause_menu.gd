extends Control

func toggle_pause():
	get_tree().paused = not get_tree().paused
	visible = not visible
	
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
