extends Node2D

@onready var timer: RichTextLabel = $timer

var time: float = 0.0

func _ready() -> void:
	# Call your Timer function with the starting time when the scene starts
	start_timer(10.0)

func _process(delta: float) -> void:
	# Display the time rounded to 1 decimal place
	timer.text = str(snapped(time, 0.1))

func start_timer(start_time: float) -> void:
	time = start_time
	
	while time > 0.0:
		await wait(0.1)
		time -= 0.1
	
	time = 0.0
	# Change to your next scene here when timer reaches 0:
	# get_tree().change_scene_to_file("res://YourNextScene.tscn")

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout
