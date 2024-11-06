extends CharacterBody3D

# Constants for movement and behavior
const MIN_SPEED = 4.0
const MAX_SPEED = 6.0
const DIRECTION_CHANGE_INTERVAL = 0.5
const SEPARATION_WEIGHT = 1.0
const ALIGNMENT_WEIGHT = 1.0
const COHESION_WEIGHT = 1.0
const SEPARATION_DISTANCE = 10.0
const ALIGNMENT_DISTANCE = 10.0
const COHESION_DISTANCE = 10.0

# Movement bounds
const X_BOUND = Vector2(-95, 95)
const Z_BOUND = Vector2(-95, 95)

# Variables for direction and timing
var speed = 0.0
var time_since_direction_change = 0.0
var direction = Vector3.ZERO

func _ready() -> void:
	add_to_group("boids")
	randomize()
	initialize_random_direction()
	initialize_random_speed()

func _physics_process(delta: float) -> void:
	time_since_direction_change += delta

	if time_since_direction_change >= DIRECTION_CHANGE_INTERVAL:
		update_direction()
		time_since_direction_change = 0.0

	apply_movement()
	check_bounds_and_reverse()
	handle_collisions()

# Initialize random starting direction
func initialize_random_direction() -> void:
	direction = Vector3(randf_range(-1.0, 1.0), 0, randf_range(-1.0, 1.0)).normalized()

func initialize_random_speed() -> void:
	speed = randf_range(MIN_SPEED, MAX_SPEED)

# Update direction based on boids behavior
func update_direction() -> void:
	var separation = calculate_separation()
	var alignment = calculate_alignment()
	var cohesion = calculate_cohesion()
	
	direction += separation * SEPARATION_WEIGHT + alignment * ALIGNMENT_WEIGHT + cohesion * COHESION_WEIGHT
	direction = direction.normalized()

# Apply movement based on current direction and adjust rotation to face movement direction
func apply_movement() -> void:
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y = 0

	# Adjust rotation to face the direction of movement
	if velocity.length() > 0.01: 
		var target_position = global_position + velocity.normalized()
		look_at(target_position, Vector3.UP)

# Check bounds and reverse direction if out of bounds
func check_bounds_and_reverse() -> void:
	if global_position.x < X_BOUND.x and direction.x < 0:
		direction.x *= -1
	elif global_position.x > X_BOUND.y and direction.x > 0:
		direction.x *= -1

	if global_position.z < Z_BOUND.x and direction.z < 0:
		direction.z *= -1
	elif global_position.z > Z_BOUND.y and direction.z > 0:
		direction.z *= -1

# Handle collisions by reversing direction
func handle_collisions() -> void:
	if move_and_slide():
		direction = -direction

# Calculate separation vector to avoid nearby boids
func calculate_separation() -> Vector3:
	var separation_vector = direction
	var nearby_boid_count = 0

	for other_boid in get_tree().get_nodes_in_group("boids"):
		if other_boid == self:
			continue
			
		var distance = global_position.distance_to(other_boid.global_position)
		if distance < SEPARATION_DISTANCE:
			separation_vector += (global_position - other_boid.global_position).normalized()
			nearby_boid_count += 1
			
	if nearby_boid_count > 0:
		separation_vector /= nearby_boid_count

	return separation_vector

# Calculate alignment vector to match nearby boids' direction
func calculate_alignment() -> Vector3:
	var alignment_vector = Vector3.ZERO
	var speed_sum = 0.0
	var nearby_boid_count = 0

	for other_boid in get_tree().get_nodes_in_group("boids"):
		if other_boid == self:
			continue

		var distance = global_position.distance_to(other_boid.global_position)
		if distance < ALIGNMENT_DISTANCE:
			alignment_vector += other_boid.velocity.normalized()
			speed_sum += other_boid.velocity.length()
			nearby_boid_count += 1
			
	if nearby_boid_count > 0:
		alignment_vector = alignment_vector.normalized()
		
		var average_speed = speed_sum / nearby_boid_count

		speed = lerp(speed, average_speed, 0.05) 

	return alignment_vector

# Calculate cohesion vector to move towards nearby boids
func calculate_cohesion() -> Vector3:
	var center_of_mass = Vector3.ZERO
	var nearby_boid_count = 0

	for other_boid in get_tree().get_nodes_in_group("boids"):
		if other_boid == self:
			continue
			
		var distance = global_position.distance_to(other_boid.global_position)
		if distance < COHESION_DISTANCE:
			center_of_mass += other_boid.global_position
			nearby_boid_count += 1

	if nearby_boid_count > 0:
		center_of_mass /= nearby_boid_count
		return (center_of_mass - global_position).normalized()
	
	return Vector3.ZERO
