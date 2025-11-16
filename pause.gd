extends Node

func resume():
	get_tree().paused = false

func paused():
	get_tree().paused = true
	
func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().pause == false:
		paused()
	if Input.is_action_just_pressed("esc") and get_tree().pause == true:
		resume()
	
