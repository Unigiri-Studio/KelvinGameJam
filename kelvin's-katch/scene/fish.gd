extends CharacterBody3D

const SPEED = 5.0
const DIRECTION_CHANGE_INTERVAL = 1.0 # Interval in seconds to change direction
var time_since_direction_change = 0.0
var direction = Vector3.ZERO # Initial direction vector

func _ready() -> void:
	randomize() # Randomize seed for randomness

func _physics_process(delta: float) -> void:
	time_since_direction_change += delta

	# Change direction after the interval
	if time_since_direction_change >= DIRECTION_CHANGE_INTERVAL:
		# Generate a random direction in the x/z plane
		direction.x = randf_range(-1.0, 1.0)
		direction.z = randf_range(-1.0, 1.0)
		direction = direction.normalized() # Normalize to maintain consistent speed
		time_since_direction_change = 0.0 # Reset the timer

	# Apply movement along the x/z axes
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	# Move the character
	move_and_slide()
