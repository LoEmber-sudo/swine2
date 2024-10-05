extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_menu.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/beallitasok.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_3d.tscn")
