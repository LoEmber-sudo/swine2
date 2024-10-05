extends  CharacterBody3D
@export var player : CharacterBody3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
const SPEED = 5.0
@export var health = 1
@onready var animation_player: AnimationPlayer = $face_dir/body/AnimationPlayer
signal body_part_hit(dam)
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var face_dir: Node3D = $face_dir
@export var look_at_point : Node3D
@onready var body: Node3D = $face_dir/body
@export var damage := 1
func _ready():
	pass
#func _physics_process(delta: float) -> void:
		#body.look_at(look_at_point.global_transform.origin, Vector3.UP, true)
		#var dir = to_local(navigation_agent_3d.get_next_path_position()).normalized()
		#velocity = dir * SPEED
		##animation_player.play("run")
		#move_and_slide()
func make_path():
	navigation_agent_3d.target_position = player.global_position
	










#const speed = 5
#var is_inside = false
#@onready var timer: Timer = $Node3D2/Timer
#@onready var timer_3: Timer = $Node3D2/Timer3
#@onready var animation_player: AnimationPlayer = $body/AnimationPlayer
#func _physics_process(delta: float) -> void:
	#if is_inside == false:
		#velocity = dir * speed
		#animation_player.play("run")
		#move_and_slide()
#
#func _on_body_entered(body: Node3D) -> void:
	#timer.start(0.5)
	#print("entered")
	#timer_3.stop()
	#if timer_3.is_stopped():
		#is_inside = true
		#_on_timer_timeout()
#
#func _on_body_exited(body: Node3D) -> void:
	#timer.stop()
	#print("exited")
	#timer_3.start(0.5)
	#if timer.is_stopped():
		#is_inside = false
#

#
#func _on_timer_timeout() -> void:
		#animation_player.play("fight_punch")


func _on_timer_timeout() -> void:
	make_path()


func _on_area_3d_body_part_hit(dam: Variant) -> void:
	health -= dam
	print("hit!")
	if health <= 0:
		queue_free()
