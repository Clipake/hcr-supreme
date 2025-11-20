extends PanelContainer
@onready var run_points = $run_points.text
@onready var coin_count = $coin_count.text
var time_passed = 0
var coins = 0
var points = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint(): return
	# Events.coin_pickup_signal.connect(update_coins)
	# Events.run_points_interactable_update.connect(update_run_points)
		# unsure of these two's signal names

func update_coins() -> void:
	coins += 1
	coin_count = str(coins) + " coins"
	
func update_run_points(pts) -> void:
	points += pts
	run_points = str(points) + " run points"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed >= 1:
		update_run_points(100)
		time_passed = 0
