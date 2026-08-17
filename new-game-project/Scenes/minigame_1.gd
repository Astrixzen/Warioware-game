extends Node2D

@onready var timer_label: RichTextLabel = $Timer
@onready var level_label: RichTextLabel = $Level

var time: float = 10.0 
var garlic_collected = 0 
var timer_end = false 

func _ready() -> void:
	Timer(10.0)

func _process(delta: float) -> void: 
	timer_label.text = str(snapped(time, 0.10))
	level_label.text = "Level " + str(Global.minigames_done)
	
	# Lose Condition Check (Only fires if timer hits 0 AND player has less than 3 items)
	if timer_end and garlic_collected < 3:
		set_process(false) 
		Global.minigames_done -= 1 
		Global.lives -= 1 
		get_tree().change_scene_to_file("res://scenes/level_screen.tscn")
		return

# Mechanical timer countdown loop
func Timer(start_time: float):
	time = start_time
	
	while time > 0.0:
		if garlic_collected >= 3:
			return # Immediately kill countdown if player won
		await wait(0.1)
		time -= 0.1
		
	if garlic_collected < 3:
		time = 0.0
		timer_end = true 
	return

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
