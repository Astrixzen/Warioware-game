extends Node2D

@onready var garlic_container: HBoxContainer = $GarlicContainer
@onready var garlic: TextureRect = $GarlicContainer/Garlic
@onready var garlic_2: TextureRect = $GarlicContainer/Garlic2
@onready var garlic_3: TextureRect = $GarlicContainer/Garlic3
@onready var garlic_4: TextureRect = $GarlicContainer/Garlic4
@onready var garlic_5: TextureRect = $GarlicContainer/Garlic5
@onready var level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $Timer

var time: float = 0.0

func _ready() -> void:
	# Immediate Check: If out of lives at entry, drop instantly to game over scene file
	if Global.lives <= 0:
		safely_change_scene("game_over_scene")
		return

	# Show the full intermission screen information, wait out the 5-second countdown break
	await Timer(5.0) 
	set_process(false) # Safety loop switch to block double-transitions
	
	# Check again after the 5 seconds just in case
	if Global.lives <= 0:
		safely_change_scene("game_over_scene")
		return
		
	if Global.minigames_done >= 2:
		safely_change_scene("done_screen")
		return
	
	if Global.minigames_done < 0:
		Global.minigames_done = 0

	# Explicit game routing pathways based on current completion variables
	if Global.minigames_done == 0:
		safely_change_scene("minigame_1")
		return
	elif Global.minigames_done == 1:
		safely_change_scene("minigame_2")
		return
	else:
		safely_change_scene("title_screen") 
		return

func _process(delta: float) -> void: 
	timer.text = "%.1f" % time 
	
	if Global.minigames_done <= 0:
		level.text = "Level 0"
	else:
		level.text = "Level " + str(Global.minigames_done)
	
	# Handles your visual garlic lives display layout container system dynamically
	var children = garlic_container.get_children()
	for i in range(children.size()):
		if i < Global.lives:
			children[i].show()
		else:
			children[i].hide()

func Timer(start_time: float) -> void: 
	time = start_time 
	while time > 0.0: 
		await wait(0.1) 
		time -= 0.1 
		if time < 0:
			time = 0.0
	return

func wait(seconds: float): 
	await get_tree().create_timer(seconds).timeout

func safely_change_scene(scene_name: String) -> void:
	# Hardcode ALL variations of file names and folders to make it completely un-crashable
	var possible_paths = [
		"res://Scenes/" + scene_name + ".tscn",
		"res://scenes/" + scene_name + ".tscn",
		"res://" + scene_name + ".tscn"
	]
	
	# If we are trying to go to minigame 2, forcefully check for your capital tab names first
	if scene_name == "minigame_2":
		possible_paths.insert(0, "res://Scenes/Minigame_2.tscn")
		possible_paths.insert(1, "res://scenes/Minigame_2.tscn")
		possible_paths.insert(2, "res://Scenes/minigame_2.tscn")
		
	for path in possible_paths:
		if ResourceLoader.exists(path):
			get_tree().change_scene_to_file(path)
			return
