extends Node3D

@export var player : CharacterBody3D

#wave variables
var wave = preload("res://scene/object/wave.tscn")
var waveDistance : int = 50

func _ready() -> void:
	pass


func _on_wave_timer_timeout():
	var w = wave.instantiate()
	w.global_position = Vector3i(randi_range(player.global_position.x-waveDistance,player.global_position.x+waveDistance),0,randi_range(player.global_position.z-waveDistance,player.global_position.z+waveDistance))
	add_child(w)
	%waveTimer.start()
