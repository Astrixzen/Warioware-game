extends TextureButton

@onready var parent = $".."

# Safety switch to guarantee it can only add a point ONCE
var already_clicked: bool = false

func _on_pressed() -> void: # Connected via the Node/Signals panel next to the Inspector
	if not already_clicked:
		already_clicked = true # Instantly lock it down so it cannot run again
		hide() # Make it disappear from the UI layout
		
		# Directly modify the counter pool variable on your level root node script
		if "buttons_pressed" in parent:
			parent.buttons_pressed += 1
