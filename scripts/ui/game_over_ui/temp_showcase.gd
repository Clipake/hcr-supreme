extends Node

func _ready() -> void:
	# DEVELOPMENT FUNCTION ONLY; NOT FOR PRODUCTION
	await get_tree().create_timer(0.01).timeout # temp fix b/c it loads before signal connections
	print('running')
	var run_time = 500; var coins = 954_783_000; var diff = 2.67
	
	Events.set_run_time.emit(run_time)
	Events.set_coins_collected.emit(coins)
	Events.set_difficulty_bonus.emit(diff)
	Events.set_total.emit(((run_time*10)+coins)*diff)
	Events.restart_game.connect(restart)
	Events.open_home.connect(home)
	Events.open_shop.connect(shop)
	
	
func restart() -> void:
	# DEVELOPMENT FUNCTION ONLY; NOT FOR PRODUCTION
	print("RESTART")
func home() -> void:
	# DEVELOPMENT FUNCTION ONLY; NOT FOR PRODUCTION
	print("HOME")
func shop() -> void:
	# DEVELOPMENT FUNCTION ONLY; NOT FOR PRODUCTION
	print("SHOP")
