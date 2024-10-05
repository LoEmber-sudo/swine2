extends Control
var loaded = false

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	Audio.play_music_level()
func _on_close_pressed() -> void:
	get_tree().quit()


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://beallitasok.tscn")


func _on_play_pressed() -> void:
	if FileAccess.file_exists("user://savedgame.tres"):
		get_tree().change_scene_to_file("res://main_3d.tscn")
		loaded = true
	else:
		get_tree().change_scene_to_file("res://main_3d.tscn")

	
