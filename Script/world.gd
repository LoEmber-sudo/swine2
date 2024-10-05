extends Node3D
@export var player_global_position_x : float
@export var player_global_position_y  : float
@export var player_global_position_z  : float
@export var player_global_rotation : Vector3


var current_gun : int
var pisztoly = "AcélTüske"
var Gépfegyó = "PewPew"
var kés = "kés"
var main_scene = "res://main_3d.tscn"
#func _ready():
#	Audio.play_music_level()
func _on_vissza_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_menu.tscn")
# Function to save data to a text file
func save_game():
	var saved_game:SavedGame  = SavedGame.new()
	saved_game.player_position_x = $"/root/PlayerGlobal".player.get_position_x()
	saved_game.player_position_y = $"/root/PlayerGlobal".player.get_position_y()
	saved_game.player_position_z = $"/root/PlayerGlobal".player.get_position_z()
	ResourceSaver.save(saved_game, "user://savedgame.tres")
func load_game():
	var saved_game:SavedGame = load("user://savedgame.tres") as SavedGame
	if FileAccess.file_exists("user://savedgame.tres"): 
		player_global_position_x = saved_game.player_position_x
		player_global_position_y = saved_game.player_position_y
		player_global_position_z = saved_game.player_position_z
func _on_timer_timeout() -> void:
	save_game()
