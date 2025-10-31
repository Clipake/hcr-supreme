extends Node

# UI signals
signal restart_game
signal open_home
signal open_shop
signal set_run_time(run_time: int) ## Run time in seconds
signal set_coins_collected(coins_collected: int) ## Coins collected in run
signal set_difficulty_bonus(difficulty_bonus: float) ## Difficulty bonus up to one decimal place
signal set_total(total: int) ## Total score in run
