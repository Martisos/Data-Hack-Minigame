extends Node

var music_player: AudioStreamPlayer

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

func play_music(stream: AudioStream, volume_db: float = 0.0) -> void:
	if music_player.stream == stream and music_player.playing:
		return
	
	music_player.stream = stream
	music_player.volume_db = volume_db
	music_player.play()

func stop_playing() -> void:
	music_player.stop()

func play_sfx(stream: AudioStream, volume_db: float = 0.0, pitch_randomness: float = 0.0) -> void:
	if !stream: return
	
	var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()
	sfx_player.stream = stream
	sfx_player.bus = "SFX"
	sfx_player.volume_db = volume_db
	
	if pitch_randomness > 0.0:
		sfx_player.pitch_scale = randf_range(1.0 - pitch_randomness, 1.0 + pitch_randomness)
	
	add_child(sfx_player)
	sfx_player.play()
	
	sfx_player.finished.connect(sfx_player.queue_free)

func set_bus_volume(bus_name: String, linear_value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1: return
	
	if linear_value <= 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))

func set_master_volume(linear_value: float) -> void:
	set_bus_volume("Master", linear_value)

func set_music_volume(linear_value: float) -> void:
	set_bus_volume("Music", linear_value)

func set_sfx_volume(linear_value: float) -> void:
	set_bus_volume("SFX", linear_value)
