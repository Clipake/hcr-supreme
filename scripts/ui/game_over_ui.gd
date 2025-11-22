"""
An abstraction layer for the game over UI made for easy control over the game over UI components
"""
extends Control


func _ready() -> void:
	# Connecting to signal bus
	Events.set_run_time.connect(set_run_time)
	Events.set_coins_collected.connect(set_coins_collected)
	Events.set_difficulty_bonus.connect(set_difficulty_bonus)
	Events.set_total.connect(set_total)
	Events.game_over.connect(activate)


func activate():
	visible = true


func set_run_time(run_time: int) -> void:
	"""
	Updates the UI's run time value to run_time
	:param run_time: The run time in seconds
	"""
	var label: Label = $'BGPanel/VBoxContainer/Summary/Stats/RunTime'
	var minutes: int = run_time / 60
	var seconds: int = run_time % 60
	label.text = str(minutes) + ':' + str(seconds).lpad(2, '0') # Formats as M:SS
	
	
func set_coins_collected(coins_collected: int) -> void:
	"""
	Updates the UI's coins collected value to coins_collected
	:param coins_collected: The number of coins collected during the run
	"""
	var label: Label = $'BGPanel/VBoxContainer/Summary/Stats/CoinsCollected'
	label.text = _format_number(coins_collected)
	
	
func set_difficulty_bonus(difficulty_bonus: float) -> void:
	"""
	Updates the UI's difficulty bonus value to difficulty_bonus
	:param difficulty_bonus: The run's difficulty bonus, up to one decimal place
	"""
	var label: Label = $'BGPanel/VBoxContainer/Summary/Stats/DifficultyBonus'
	label.text = str(snappedf(difficulty_bonus, 0.1)) + 'x'
	
	
func set_total(total: int) -> void:
	"""
	Updates the UI's total score value to total
	:param total: The total score from the run
	"""
	var label: Label = $'BGPanel/VBoxContainer/Summary/Stats/Total'
	label.text = _format_number(total)

"""
Helper functions to connect UI buttons to signal bus
"""
func _on_restart_game() -> void:
	Events.restart_game.emit()
func _on_open_home() -> void:
	Events.open_home.emit()
func _on_open_shop() -> void:
	Events.open_shop.emit()


func _format_number(number: float) -> String:
	"""
	Formats a number into thousands (K), millions (M), or B (billions)
	
	Numbers less than 10K are plain. Anything else is condensed down to one decimal place.
	"""
	if number < 10_000: # 1-9999
		return str(int(number))
	elif number < 1_000_000: # 1K-999K
		return str(snappedf(number/1_000, 0.1)) + 'K'
	elif number < 1_000_000_000: # 1M-999M
		return str(snappedf(number/1_000_000, 0.1)) + 'M'
	else: # 1B+
		return str(snappedf(number/1_000_000_000, 0.1)) + 'B'
