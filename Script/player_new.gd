extends CharacterBody3D
@onready var character_body_3d: CharacterBody3D = $"."
@onready var nek: Node3D = $nek
@onready var pivot: Node3D = $nek/Pivot
@onready var col_crouching: CollisionShape3D = $crouching
@onready var standing: CollisionShape3D = $standing
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var camera_3d: Camera3D = $nek/Pivot/eyes/Camera3D
@onready var eyes: Node3D = $nek/Pivot/eyes
@onready var label_2: Label = $HUD/Label2
@onready var label_4: Label = $HUD/Label4
@onready var _cs__: MeshInstance3D = $"nek/Pivot/eyes/Camera3D/weapon_manager/fps_rig/Acéltüske (1)/*cső*"
@onready var gun_raycast: RayCast3D = $"nek/Pivot/eyes/Camera3D/weapon_manager/fps_rig/Acéltüske (1)/bullet_spawn/RayCast3D"
@onready var animation_player: AnimationPlayer = $"nek/Pivot/eyes/Camera3D/weapon_manager/fps_rig/Acéltüske (1)/AnimationPlayer"
var last_vel = Vector3.ZERO
var bullet = load("res://bullet.tscn")
var bullet_trail = load("res://bullettrail.tscn")
@onready var aim_raycast_end: Node3D = $nek/Pivot/eyes/Camera3D/aim_raycast_end


var instance
const BULLET_SPEED = 10.0
var current_gun : int
var pisztoly = "AcélTüske"
var pisztoly_ammo = 8
var pisztoly_tár = 5
var pisztoly_eq = false
var Gépfegyó = "PewPew"
var Gépfegyó_ammo = 25
var Gépfegyó_tár = 8 
var kés = "kés"
var mouse_sense = 0.1
var SPEED_CURRENT = 5.0
const JUMP_VELOCITY = 4.5
var walking_speed = 7.0
var head_bobbing_sprinting_speed = 22.0
var head_bobbing_walking_speed = 14.0
var head_bobbing_crouching_speed = 10.0
var head_bobbing_sprinting_intensity = 0.2
var head_bobbing_walking_intensity = 0.1
var head_bobbing_crouching_intensity = 0.05
var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_current = 0.0
var lerp_speed = 10.0
var air_lerp_speed = 3
var position_x = Vector3.ZERO
var sliding_timer = 0.0
var sliding_timer_max = 1.0
var slide_vector = Vector3.ZERO
var crouching_depth = -0.2
var direction = Vector3.ZERO
var sprinting_speed = 10.0
var crouching_speed = 5.0
var sliding = false
var walking = false
var freelooking = false
var freelook_tilt = 8
var sprinting = false
var crouching = false
var slide_speed = 10.0
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$"/root/PlayerGlobal".register_player(self)
	World.load_game()
	Audio.lower_volume()
	if FileAccess.file_exists("user://savedgame.tres"):
		self.global_translate(Vector3(World.player_global_position_x,World.player_global_position_y,World.player_global_position_z))
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _input(event):
	if event is InputEventMouseMotion:
		if freelooking:
			nek.rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
			nek.rotation.y = clamp(nek.rotation.y, deg_to_rad(-110), deg_to_rad(110))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
			pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))
func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	# SHOOT
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if !animation_player.is_playing():
			if current_gun == 2:
				if pisztoly_ammo > -1:
					animation_player.play("AcélTüske_lövés")
					label_4.text = str(pisztoly_ammo) + "x" + str(pisztoly_tár)
					instance = bullet.instantiate()
					pisztoly_ammo -= 1
					instance.position = gun_raycast.global_position
					#instance.get_node("bullet_1/MeshInstance3D").scale = Vector3(0.4, 0.4, 0.4)
					instance.transform.basis = gun_raycast.global_transform.basis * 1 * BULLET_SPEED
					get_parent_node_3d().add_sibling(instance)
	if Input.is_action_pressed("reload"):
		if pisztoly_tár > 0:
			if pisztoly_ammo < 1:
				pisztoly_ammo = 8
				animation_player.play("AcélTüske_reload")
				pisztoly_tár -= 1
				label_4.text = str(pisztoly_ammo) + "x" + str(pisztoly_tár)
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_pressed("crouch") || sliding:
		SPEED_CURRENT = lerp(SPEED_CURRENT, crouching_speed, delta*lerp_speed)
		pivot.position.y = lerp(pivot.position.y, 0.0 + crouching_depth,delta*lerp_speed)
		standing.disabled = true
		col_crouching.disabled = false
		if sprinting && input_dir != Vector2.ZERO:
			sliding = true
			sliding_timer = sliding_timer_max
			slide_vector = input_dir
			freelooking = true
			
		walking = false
		sprinting = false
		crouching = true
		
	elif !ray_cast_3d.is_colliding():
		pivot.position.y = 0.0
		standing.disabled = false
		col_crouching.disabled = true
		if Input.is_action_pressed("sprint"):
			SPEED_CURRENT = lerp(SPEED_CURRENT, sprinting_speed, delta*lerp_speed)
			walking = false
			sprinting = true
			crouching = false
		else:
			SPEED_CURRENT = lerp(SPEED_CURRENT, walking_speed, delta*lerp_speed)
			walking = true
			sprinting = false
			crouching = false
	if Input.is_action_pressed("free_look") || sliding:
		freelooking = true
		if sliding:
			eyes.rotation.z = lerp(eyes.rotation.z,-deg_to_rad(7.0), delta * lerp_speed)
		else:
			eyes.rotation.z = -deg_to_rad(nek.rotation.y*freelook_tilt)
	else:
		freelooking = false
		nek.rotation.y = lerp(nek.rotation.y, 0.0, lerp_speed * delta)
		eyes.rotation.z = lerp(nek.rotation.z, 0.0, lerp_speed * delta)
	if sliding:
		sliding_timer -= delta
		if sliding_timer <= 0:
			sliding = false
			freelooking = false
	if sprinting:
		head_bobbing_current = head_bobbing_sprinting_intensity
		head_bobbing_index += head_bobbing_sprinting_speed*delta
	elif walking:
		head_bobbing_current = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed*delta
	elif crouching: 
		head_bobbing_current = head_bobbing_crouching_intensity
		head_bobbing_index += head_bobbing_crouching_speed*delta
	if is_on_floor() && !sliding && input_dir != Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index/2) + 0.5
		
		eyes.position.y = lerp(eyes.position.y, head_bobbing_vector.y * (head_bobbing_current/2.0), delta * lerp_speed)
		eyes.position.x = lerp(eyes.position.x, head_bobbing_vector.x * (head_bobbing_current), delta * lerp_speed)
	else:
		eyes.position.y = lerp(eyes.position.y, 0.0, delta * lerp_speed)
		eyes.position.x = lerp(eyes.position.x, 0.0, delta * lerp_speed)
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#animation_player.play("jumping")
	#if is_on_floor():
		#if last_vel.y < -10.0:
			#animation_player.play("roll")
	if is_on_floor():
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	else:
		if input_dir != Vector2.ZERO:
			direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*air_lerp_speed)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if sliding:
		direction = transform.basis * Vector3(slide_vector.x, 0, slide_vector.y).normalized()
		SPEED_CURRENT = (sliding_timer + 0.1) * slide_speed
	if direction:
		velocity.x = direction.x * SPEED_CURRENT
		velocity.z = direction.z * SPEED_CURRENT
#
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED_CURRENT)
		velocity.z = move_toward(velocity.z, 0, SPEED_CURRENT)
	last_vel = velocity
	move_and_slide()
func get_position_x():
	return self.global_position.x
func get_position_y():
	return self.global_position.y
func get_position_z():
	return self.global_position.z
func get_rotation_():
	return self.global_basis
func _process(delta: float) -> void:
	eq()
func eq():
	if Input.is_action_just_pressed("eq_1"):
		if current_gun == 2:
			animation_player.play("AcélTüske_eltétel")
		current_gun = 1
		label_2.text = Gépfegyó
		label_4.text = str(Gépfegyó_ammo) + "x" + str(Gépfegyó_tár)
	if Input.is_action_just_pressed("eq_2"):
		animation_player.play("AcélTüske_elővétel")
		current_gun = 2
		label_4.text = str(pisztoly_ammo) + "x" + str(pisztoly_tár)
		label_2.text = pisztoly
	if Input.is_action_just_pressed("eq_3"):
		if current_gun == 2:
			animation_player.play("AcélTüske_eltétel")
		current_gun = 3
		label_2.text = kés
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_menu.tscn")
