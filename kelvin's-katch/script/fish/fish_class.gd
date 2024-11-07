extends Resource

class_name fish_class

# Constants for movement and behavior
@export var swiming_type: int #1: linear, 2: stuttered
@export var fish_sprite: CompressedTexture2D
@export var speed: float
@export var direction_change_interval: float
@export var stop_time_interval: float
@export var separation_weight: float
@export var alignment_weight: float
@export var cohesion_weight: float
@export var separation_radius: float
@export var alignment_radius: float
@export var cohesion_radius: float
@export var species: String

# Variables for direction and timing
var time_since_direction_change = 0.0
var time_since_stop = 0.0
var is_stopped = false;
var direction = Vector3.ZERO

# Custom initialization
func initialize() -> void:
	randomize()
	initialize_random_direction()

# Initialize random starting direction
func initialize_random_direction() -> void:
	direction = Vector3(randf_range(-1.0, 1.0), 0, randf_range(-1.0, 1.0)).normalized()

# Update direction based on boids behavior (stub method)
func update_direction(separation: Vector3, alignment: Vector3, cohesion: Vector3) -> void:
	direction += separation * separation_weight + alignment * alignment_weight + cohesion * cohesion_weight
	direction = direction.normalized()
