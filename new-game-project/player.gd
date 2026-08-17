extends CharacterBody2D

# Movement constants (Adjust these to change game feel)
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# 1. Apply Gravity if the player is in the air
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Handle Jump (Using 'W' key mapped to 'jump')
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Get direction based on 'A' and 'D' keys
	# 'move_left' (A) returns -1, 'move_right' (D) returns 1
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		# Smoothly slow down the character when keys are released
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. Engine built-in physics handler (handles collisions automatically)
	move_and_slide()
