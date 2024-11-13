extends AudioStreamPlayer2D

# Use a variable instead of a constant so we can modify it
var level_music = preload("res://asset/resource/audio/Fish Game Unfinished.mp3")

func _ready():
	# Set the loop property on the audio stream to enable looping
	if level_music is AudioStream:
		level_music.loop = true

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return

	stream = music
	volume_db = volume
	play()

func play_music_level():
	_play_music(level_music)
