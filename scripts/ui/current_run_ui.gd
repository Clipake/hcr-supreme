extends Control

func _ready() -> void:
	Events.set_coins_collected.connect(_set_coins_collected)
	Events.set_total.connect(_set_score)
	
func _set_coins_collected(coins: int):
	$VBoxContainer/CoinLabel.text = 'Coins: ' + str(coins)
	
func _set_score(score: int):
	$VBoxContainer/ScoreLabel.text = 'Score: ' + str(score)
