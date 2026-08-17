extends Node2D

@onready var self_area: Area2D = $Area2D
var is_collected: bool = false

func _ready() -> void:
	self_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if it's the player character stepping into the zone layout boundaries
	if body.name == "Player" and self.visible and not is_collected:
		is_collected = true
		
		# FIX: Run the hide and scoring mechanics SAFELY after the physics frame finishes calculating
		call_deferred("_handle_safe_collection")

func _handle_safe_collection() -> void:
	self.hide() # Make the item clean disappear visually
	
	var main_game = get_tree().current_scene
	if is_instance_valid(main_game) and main_game.has_method("garlic_collect"):
		main_game.garlic_collect()
