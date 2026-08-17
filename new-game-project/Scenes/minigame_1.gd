extends Node2D

# Grab your custom dragged-in ThemedTimer node instance
@onready var themed_timer: Node2D = $ThemedTimer

var garlic_collected = 0 
var timer_end = false 

func _ready() -> void:
	# 1. Fire off the countdown loop inside your child ThemedTimer
	themed_timer.Timer(10.0)
	
	# 2. Halt this function execution right here until the timer loop completes
	await themed_timer.timer_finished
	
	# 3. Flips your flag once time officially hits zero
	timer_end = true 

func _process(delta: float) -> void: 
	# Win Condition Check
	if garlic_collected == 3:
		set_process(false) # Lock down the loop so scene transitions only trigger ONCE
		Global.minigames_done = 1 # Force progression tracking state to level 1 complete
		safely_change_scene("level_screen")
		return
	
	# Lose Condition Check
	if timer_end:
		set_process(false) # Lock down the loop so scene transitions only trigger ONCE
		Global.lives -= 1
		Global.minigames_done -= 1
		if Global.minigames_done < 0:
			Global.minigames_done = 0
			
		safely_change_scene("level_screen")
		return

# Connected to your physical garlic item node safe deferred signals
func garlic_collect() -> void:
	if not timer_end:
		garlic_collected = garlic_collected + 1

# Path-safe scene switching engine tool
func safely_change_scene(scene_name: String) -> void:
	var possible_paths = [
		"res://Scenes/" + scene_name + ".tscn",
		"res://scenes/" + scene_name + ".tscn",
		"res://" + scene_name + ".tscn"
	]
	for path in possible_paths:
		if ResourceLoader.exists(path):
			get_tree().change_scene_to_file(path)
			return
