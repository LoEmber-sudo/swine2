extends Control
@onready var option_button = $OptionButton as  OptionButton
@onready var panel: Panel = $Panel

const WiNDOW_MODE_ARRAY :  Array[String] = [
	"Teljesképernyő (ajánlott)",
	"Ablak Mód",
	"Maximalizált",
]
func _process(delta: float) -> void:
	centre_window()
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/Main_menu.tscn")
		
func centre_window():
	var centre_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(centre_screen - window_size/2)
func _ready():
	add_window_mode_items()
	option_button.item_selected.connect(on_window_mode_selected)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func add_window_mode_items():
	for window_mode in WiNDOW_MODE_ARRAY:
		option_button.add_item(window_mode)
func on_window_mode_selected(index : int) -> void:
	match index:
		0: #fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag (DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag (DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_flag (DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
			DisplayServer.window_set_flag (DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_menu.tscn")


func _on_restart_pressed() -> void:
	panel.visible = true
	


func _on_button_2_pressed() -> void:
	panel.visible = false


func _on_ja_pressed() -> void:
	if FileAccess.file_exists("user://savedgame.tres"):
		DirAccess.remove_absolute("user://savedgame.tres")
