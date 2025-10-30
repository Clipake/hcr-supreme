"""
An abstraction layer for the game over UI made for easy control over the game over UI components
"""
extends Control

signal restart # Emitted when player releases the restart button


func _ready() -> void:
	# DEVELOPMENT FUNCTION ONLY; NOT FOR PRODUCTION
	set_run_time(500)
	set_coins_collected(95000)
	set_difficulty_bonus(2.67)
	restart.connect(temp)
	
	
func temp() -> void:
	# DEVELOPMENT FUNCTION ONLY; NOT FOR PRODUCTION
	print("Restart button triggered and detected via abstraction system!")


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
	label.text = str(coins_collected)
	
	
func set_difficulty_bonus(difficulty_bonus: float) -> void:
	"""
	Updates the UI's difficulty bonus value to difficulty_bonus
	:param difficulty_bonus: The run's difficulty bonus, up to one decimal place
	"""
	var label: Label = $'BGPanel/VBoxContainer/Summary/Stats/DifficultyBonus'
	label.text = str(snappedf(difficulty_bonus, 0.1)) + 'x'


func _on_restart() -> void:
	"""
	Helper function that connects to the restart button's button_up() signal
	"""
	restart.emit()
