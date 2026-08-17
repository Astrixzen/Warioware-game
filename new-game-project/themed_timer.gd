extends Node2D

@onready var timer_label: RichTextLabel = $timer

# 1. We create a custom signal at the very top of the script
signal timer_finished

var time: float

func _process(delta: float) -> void:
	timer_label.text = str(snapped(time, 0.10))

func Timer(start_time: float):
	time = start_time
	
	while time > 0.0:
		await wait(0.1)
		time -= 0.1
	
	time = 0.0
	
	# 2. The exact moment the timer reaches 0, we blast out this signal!
	timer_finished.emit()
	return

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
