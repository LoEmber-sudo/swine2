extends AudioStreamPlayer
@onready var audio_stream_player: AudioStreamPlayer = $"."

#const load_music = preload("")
# Called when the node enters the scene tree for the first time.
func  _play_music(music : AudioStream, volume = 0.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func play_music_level():
#	_play_music(load_music)
func stop_music():
	if get_tree().get_current_scene().scene_file_path == "res://main_3d.tscn": 
		audio_stream_player.stop()
func lower_volume():
	if get_tree().get_current_scene().scene_file_path == "res://main_3d.tscn": 
		audio_stream_player.volume_db = -5.0
	else:
			audio_stream_player.volume_db = 0.0
