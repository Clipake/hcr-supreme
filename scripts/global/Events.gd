extends Node

# General game signals
signal restart_game ## Signal for restart game by game over UI and pause UI
signal start_game ## Signal for start of game by start UI
signal pause_game ## Triggered by pause UI
signal unpause_game ## Triggered by pause UI

# UI signals
signal open_home ## Go back to home screen
signal open_shop ## Open shop UI

signal set_run_time(run_time: int) ## Sets game over UI's run time to run_time
signal set_coins_collected(coins_collected: int) ## Sets game over UI's coins collected to coins_collected
signal set_difficulty_bonus(difficulty_bonus: float) ## Sets game over UI's difficulty bonus to difficulty_bonus
signal set_total(total: int) ## Sets game over UI's total score to total
signal set_player_health(health: int) ## Sets health UI to health
