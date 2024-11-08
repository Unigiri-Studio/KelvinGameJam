extends Node3D

@export var player : CharacterBody3D

#wave variables
var wave = preload("res://scene/object/wave.tscn")
var waveDistance : int = 50

@export_category("Fish Varaibles")
@export var max_fish : int = 50
@export var fish_bounds_dist : int = 150

@onready var fishContainer = $fishContainer
var fish_scene = load("res://scene/fish/fish.tscn")
var total_fish : int = 0
const MIN_DISTANCE_BETWEEN_FISH = 20.0
#fish bounds
var x_range : Vector2  # x-axis
var z_range : Vector2  # z-axis

var fish_species_resource_path : Array[String] = []
var fish_species_name : Dictionary

var current_fishies : Array = []


func _ready() -> void:
	updateFishBounds() # init fish bounds
	populate_fish_species("res://asset/resource/fish/") #setup
	initOcean()


func _process(delta):
	updateFishBounds()#update fish bounds
	total_fish = current_fishies.size() #update total fish in main

## wave spawning logic
func _on_wave_timer_timeout():
	var w = wave.instantiate()
	w.global_position = Vector3i(randi_range(player.global_position.x-waveDistance,player.global_position.x+waveDistance),0,randi_range(player.global_position.z-waveDistance,player.global_position.z+waveDistance))
	add_child(w)
	%waveTimer.start()

##################################
#helper functions
##################################

func initOcean():
	for i in range(max_fish):
		var randomFishInd = randi_range(0,len(fish_species_resource_path)-1)
		var speciesName = ""
		for key in fish_species_name.keys():
			if fish_species_name[key] == randomFishInd:
				speciesName = key
				break
		if (speciesName == ""):
			print("could not find a fish")
			break
		spawnFish(speciesName)

func spawnFish(species : String):
	var fish = fish_scene.instantiate()
	fish.fish_data = load(fish_species_resource_path[fish_species_name[species]]).duplicate()
	var depth = fish.fish_data.depth
	var position = get_random_position(depth)
	fish.global_position = position
	fishContainer.add_child(fish)
	current_fishies.append(fish)
	
func removeFish(fish_instance):
	if(fish_instance in current_fishies):
		current_fishies.erase(fish_instance)

func updateFishBounds():
	x_range = Vector2(player.global_position.x-fish_bounds_dist, player.global_position.x+fish_bounds_dist)
	z_range = Vector2(player.global_position.z-fish_bounds_dist, player.global_position.z+fish_bounds_dist)
	for fish in current_fishies:
		fish.X_BOUND = x_range
		fish.Z_BOUND = z_range

## clears all fish from everything
func clear_fish():
	total_fish = 0
	current_fishies.clear()

## returns a valid random position in bounds that is not obstructed by a fish
func get_random_position(depth: float) -> Vector3:
	var position
	var is_position_valid = false
	
	while not is_position_valid:
		# Use depth for the Y position
		position = Vector3(randf_range(x_range.x, x_range.y), depth, randf_range(z_range.x, z_range.y))
		is_position_valid = true

		for fish in fishContainer.get_children():
			if fish.global_position.distance_to(position) < MIN_DISTANCE_BETWEEN_FISH:
				is_position_valid = false
				break

	return position

## fills the global varible relating to fish species with all fish_class resources in the given folder
func populate_fish_species(SpeciesDir : String):
	var dir = DirAccess.open(SpeciesDir)
	if dir:
		dir.list_dir_begin()
		var ind = 0 #init dictionary indexing
		var speciesName = dir.get_next()
		while speciesName != "":
			fish_species_resource_path.append(SpeciesDir + speciesName)
			fish_species_name[speciesName.split('.')[0]] = ind
			ind += 1
			speciesName = dir.get_next()
	else:
		print("error: cannot get Species Directory")
