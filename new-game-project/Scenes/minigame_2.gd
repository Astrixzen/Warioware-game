extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer

var buttons_pressed := 0
var timer_end = false

func _ready() -> void:
	# Start your custom 3-second challenge
	themed_timer.Timer(3.0)
	
	# Wait for the countdown loop to complete
	await themed_timer.timer_finished
	timer_end = true 

func _process(delta: float) -> void:
	# WIN CONDITION CHECK: Trigger victory the exact microsecond all 4 buttons are hit
	if buttons_pressed == 4:
		set_process(false) # Lock down frame processing loop safely
		
		# Set global progress to 2! This tells the level screen you beat both games
		Global.minigames_done = 2 
		
		safely_change_scene("level_screen") # FIXED: Target your real scene file name!
		return
	
	# LOSE CONDITION CHECK
	if timer_end and buttons_pressed < 4:
		set_process(false) # Lock down frame processing loop safely
		Global.lives -= 1
		Global.minigames_done -= 1
		if Global.minigames_done < 0:
			Global.minigames_done = 0
			
		safely_change_scene("level_screen") # FIXED: Target your real scene file name!
		return

# Path-safe scene switching tool
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
