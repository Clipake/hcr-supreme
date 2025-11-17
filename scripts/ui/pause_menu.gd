extends Control

var game_paused: bool = false

func resume():
	Events.pause_game.emit()

func paused():
	Events.unpause_game.emit()
	
func testEsc():
	if Input.is_action_just_pressed('game_pause'):
		resume() if game_paused else paused()

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed():
	Events.end_game.emit()

func _process(_delta):
	testEsc()
