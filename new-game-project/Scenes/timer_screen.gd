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
	# Show everything first, wait out the 5-second intermission
	await Timer(5.0) 
	
	set_process(false) # Safety switch to prevent loop bugs during transition
	
	# FIXED ROUTING: If Level 1 was just completed, boot up minigame_2 next! (CAPITAL S)
	if Global.minigames_done == 1:
		get_tree().change_scene_to_file("res://Scenes/Minigame_2.tscn")
	elif Global.minigames_done < 3:
		get_tree().change_scene_to_file("res://Scenes/minigame_" + str(Global.minigames_done + 1) + ".tscn") 
	else:
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn") 

func _process(delta: float) -> void: 
	timer.text = "%.1f" % time 
	level.text = "Level " + str(Global.minigames_done) # Displays "Level 1" cleanly
	
	# Keeps your physical life count icons displayed accurately based on your health pool
	match Global.lives:
		4:
			garlic.hide()
		3:
			garlic.hide()
			garlic_2.hide()
		2:
			garlic.hide()
			garlic_2.hide()
			garlic_3.hide()
		1:
			garlic.hide()
			garlic_2.hide()
			garlic_3.hide()
			garlic_4.hide()
		0:
			garlic_container.hide() 

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
