# FishInstance.gd
extends Node3D

@export var fish_data: fish_class  

const CLOSE_DISTANCE = 4.0

# Constants for movement bounds
var X_BOUND = Vector2(-150, 150)
var Z_BOUND = Vector2(-150, 150)

# Fish's movement direction and speed
var velocity = Vector3.ZERO
var update_interval = 0.0  
var update_timer = 0.0 

func _ready() -> void:
	if fish_data != null:
		fish_data.initialize() 
		add_to_group(fish_data.species)
		randomize_position()
		fish_data.initialize_random_direction()
		# Add random offsets to intervals for variation
		fish_data.direction_change_interval += randf_range(-0.2, 0.2)
		if fish_data.swiming_type == 2:
			fish_data.stop_time_interval += randf_range(-0.5, 0.5)
		
		update_interval = randf_range(0.1, 0.5)
		
		if fish_data.swimming_sprite != null:
			var sprite = Sprite3D.new()
			sprite.texture = fish_data.swimming_sprite
			match fish_data.swiming_type:
				1:
					sprite.rotation_degrees = Vector3(-90, 0, 0)
				2: 
					sprite.rotation_degrees = Vector3(-90, 0, 0)
			add_child(sprite)
		else:
			print("Warning: fish_data.fish_sprite is null")
	else:
		print("Error: fish_data is null. Please assign a fish_class resource.")

func _physics_process(delta: float) -> void:
	if fish_data != null:
		update_timer += delta
		if update_timer >= update_interval:
			update_direction_if_needed(delta)
			update_timer = 0.0

		if fish_data.swiming_type == 1:
			handle_swim_type_1(delta)
		elif fish_data.swiming_type == 2:
			handle_swim_type_2(delta)
			
func update_direction_if_needed(delta: float) -> void:
	fish_data.time_since_direction_change += delta
	if fish_data.time_since_direction_change >= fish_data.direction_change_interval:
		var separation = calculate_separation()
		var alignment = calculate_alignment()
		var cohesion = calculate_cohesion()
		fish_data.update_direction(separation, alignment, cohesion)
		fish_data.time_since_direction_change = 0.0

func handle_swim_type_1(delta: float) -> void:
	apply_movement(delta)
	check_bounds_and_reverse()
	check_close_proximity()

func handle_swim_type_2(delta: float) -> void:
	fish_data.time_since_stop += delta

	if fish_data.is_stopped:
		handle_stopped_state(delta)
	else:
		handle_moving_state(delta)

func handle_stopped_state(delta: float) -> void:
	if fish_data.time_since_stop >= fish_data.stop_time_interval:
		fish_data.is_stopped = false
		fish_data.time_since_stop = 0.0
	elif fish_data.time_since_direction_change >= fish_data.direction_change_interval:
		update_direction_if_needed(delta)

func handle_moving_state(delta: float) -> void:
	apply_movement(delta)
	check_bounds_and_reverse()
	check_close_proximity()

	if fish_data.time_since_stop >= fish_data.direction_change_interval:
		fish_data.is_stopped = true
		fish_data.time_since_stop = 0.0

# Apply movement using global_position
func apply_movement(delta: float) -> void:
	velocity.x = fish_data.direction.x * fish_data.speed
	velocity.z = fish_data.direction.z * fish_data.speed

	# Update position based on velocity and delta time
	global_position += velocity * delta

	# Rotate to face the direction of movement
	if velocity.length() > 0.01:
		var target_position = global_position + velocity.normalized()
		look_at(target_position, Vector3.UP)

# Check bounds and teleport to the opposite side without changing direction
func check_bounds_and_reverse() -> void:
	var margin = 0.1  
	print("Before: ", global_position)

	# Check X bounds
	if global_position.x < X_BOUND.x:
		global_position.x = X_BOUND.y - margin
	elif global_position.x > X_BOUND.y:
		global_position.x = X_BOUND.x + margin

	# Check Z bounds
	if global_position.z < Z_BOUND.x:
		global_position.z = Z_BOUND.y - margin
	elif global_position.z > Z_BOUND.y:
		global_position.z = Z_BOUND.x + margin

	print("After: ", global_position)


func check_close_proximity() -> void:
	for other_boid in get_tree().get_nodes_in_group(fish_data.species):
		if other_boid == self:
			continue
		var distance = global_position.distance_to(other_boid.global_position)
		if distance < CLOSE_DISTANCE:
			#print("Close proximity detected with:", other_boid.name)
			fish_data.direction = -fish_data.direction
			break 

# Set initial random position
func randomize_position() -> void:
	global_position = Vector3(randf_range(X_BOUND.x, X_BOUND.y), fish_data.depth, randf_range(Z_BOUND.x, Z_BOUND.y))

# Calculate separation vector to avoid nearby boids
func calculate_separation() -> Vector3:
	var separation_vector = fish_data.direction
	var nearby_boid_count = 0

	for other_boid in get_tree().get_nodes_in_group(fish_data.species):
		if other_boid == self:
			continue
			
		var distance = global_position.distance_to(other_boid.global_position)
		if distance < fish_data.separation_radius:
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

	for other_boid in get_tree().get_nodes_in_group(fish_data.species):
		if other_boid == self:
			continue

		var distance = global_position.distance_to(other_boid.global_position)
		if distance < fish_data.alignment_radius:
			alignment_vector += other_boid.velocity.normalized()
			speed_sum += other_boid.velocity.length()
			nearby_boid_count += 1
			
	if nearby_boid_count > 0:
		alignment_vector = alignment_vector.normalized()
		var average_speed = speed_sum / nearby_boid_count
		fish_data.speed = lerp(fish_data.speed, average_speed, 0.05)

	return alignment_vector

# Calculate cohesion vector to move towards nearby boids
func calculate_cohesion() -> Vector3:
	var center_of_mass = Vector3.ZERO
	var nearby_boid_count = 0

	for other_boid in get_tree().get_nodes_in_group(fish_data.species):
		if other_boid == self:
			continue
			
		var distance = global_position.distance_to(other_boid.global_position)
		if distance < fish_data.cohesion_radius:
			center_of_mass += other_boid.global_position
			nearby_boid_count += 1

	if nearby_boid_count > 0:
		center_of_mass /= nearby_boid_count
		return (center_of_mass - global_position).normalized()
	
	return Vector3.ZERO
