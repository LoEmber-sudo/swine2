extends Node3D
const SPEED = 20
@onready var ray_cast_3d: RayCast3D = $bullet_1/RayCast3D
@onready var bullet_1: Node3D = $bullet_1
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
func _process(delta:) -> void:
	position += transform.basis * Vector3(0,0, SPEED) * delta
	if ray_cast_3d.is_colliding():
		#bullet_1.visible = false
		print("collided!")
		if ray_cast_3d.get_collider().is_in_group("enemy"):
			ray_cast_3d.get_collider().hit()
			print("collided with enemy!")
			await get_tree().create_timer(0.7).timeout
			free()
