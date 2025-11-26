extends Node

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
