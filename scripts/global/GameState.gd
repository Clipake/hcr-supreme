extends Node

@export var init_run_speed: float = 3.0 ## The initial run speed

# Internal GameState variables
var run_speed = init_run_speed
var health: int = 3000:
	set(value):
		health = clamp(value, 0, 3000)
		Events.set_player_health.emit(health)
		if health <= 0:
			Events.game_over.emit()
		
var score: int = 0:
	set(value):
		score = value
		Events.set_total.emit(score)

var stunned: bool = false
var invincible: bool = false

# Small helper function for game restarts
func reset() -> void:
	run_speed = init_run_speed
	health = 3000
	score = 0
	stunned = false
	invincible = false
