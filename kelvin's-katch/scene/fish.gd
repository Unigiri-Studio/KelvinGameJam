extends CharacterBody3D

const SPEED = 5.0
const DIRECTION_CHANGE_INTERVAL = 1.0 # Interval in seconds to change direction
var time_since_direction_change = 0.0
var direction = Vector3.ZERO # Initial direction vector

# setting the possible area for fish movement
const X_BOUND = Vector2(-100, 100)
const Z_BOUND = Vector2(-100, 100)

func _ready() -> void:
	randomize() # Randomize seed for randomness
	# Initialize a random direction for the fish
	direction = Vector3(randf_range(-1.0, 1.0), 0, randf_range(-1.0, 1.0)).normalized()

func _physics_process(delta: float) -> void:
	time_since_direction_change += delta

	# Change direction after the interval
	if time_since_direction_change >= DIRECTION_CHANGE_INTERVAL:
		# Generate a new random direction in the x/z plane
		direction.x = randf_range(-1.0, 1.0)
		direction.z = randf_range(-1.0, 1.0)
		direction = direction.normalized() # Normalize to maintain consistent speed
		time_since_direction_change = 0.0 # Reset the timer

	# Apply movement along the x/z axes
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	velocity.y = 0

	# Check boundaries and reverse direction if out of bounds
	if global_position.x < X_BOUND.x and direction.x < 0:
		direction.x *= -1
	elif global_position.x > X_BOUND.y and direction.x > 0:
		direction.x *= -1

	if global_position.z < Z_BOUND.x and direction.z < 0:
		direction.z *= -1
	elif global_position.z > Z_BOUND.y and direction.z > 0:
		direction.z *= -1

	# Move the character and handle collision
	var collision = move_and_slide()
	if collision:
		# Reverse direction upon collision
		direction = -direction
