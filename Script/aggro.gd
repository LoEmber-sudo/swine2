extends Area3D

func _on_body_entered(body: Node3D) -> void:
	_on_timer_timeout()



func _on_timer_timeout() -> void:
	pass


func _on_body_exited(body: Node3D) -> void:
	_on_timer_2_timeout()


func _on_timer_2_timeout() -> void:
	pass
