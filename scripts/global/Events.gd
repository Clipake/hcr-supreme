extends Node

# UI signals
signal restart_game
signal start_game


signal open_home
signal open_shop
signal set_run_time(run_time: int) ## Sets game over UI's run time to run_time
signal set_coins_collected(coins_collected: int) ## Sets game over UI's coins collected to coins_collected
signal set_difficulty_bonus(difficulty_bonus: float) ## Sets game over UI's difficulty bonus to difficulty_bonus
signal set_total(total: int) ## Sets game over UI's total score to total
signal set_player_health(health: int) ## Sets health UI to health
