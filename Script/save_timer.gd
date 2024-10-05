extends Timer
@onready var timer: Timer = $"."
func _ready() -> void:
	timer.autostart = true
	
