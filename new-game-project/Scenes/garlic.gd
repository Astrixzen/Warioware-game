extends Node2D

@onready var self_area: Area2D = $Area2D
var is_collected: bool = false

func _ready() -> void:
	self_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	var main_game = get_tree().current_scene
	
	if body.name == "Player" and self.visible and not is_collected:
		is_collected = true 
		self.hide() 
		
		main_game.garlic_collected += 1
		
		# INSTANT WIN CHECK
		if main_game.garlic_collected >= 3:
			main_game.set_process(false) 
			
			# 1. Bump the counter up right here so the level screen reads "Level 1"
			Global.minigames_done = 1 
			
			# 2. Go straight to your intermission screen layout (CAPITAL S)
			get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
