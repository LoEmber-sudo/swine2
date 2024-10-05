extends Control
@export var Side = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_menu.tscn")


func _on_diszno_pressed() -> void:
	#get_tree().change_scene_to_file("res://video.tscn")
	Side = 1
	get_tree().change_scene_to_file("res://main_3d.tscn")
func _on_nyul_pressed() -> void:
	pass



func _on_close_pressed() -> void:
	get_tree().quit()
