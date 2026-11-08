extends CharacterBody3D
class_name ArenaRobot

signal health_changed(current: int, maximum: int)
signal defeated

const CombatRules = preload("res://scripts/combat_rules.gd")
const MAX_HEALTH := 100
const ATTACK_RANGE := 2.35
const WALK_SPEED := 5.25
const GUARD_DURATION := 1.1
const GUARD_COOLDOWN := 3.0

var player_controlled := false
var display_name := "Robot"
var body_color := Color(0.10, 0.80, 0.95)
var opponent: ArenaRobot
var health := MAX_HEALTH
var _cooldown := 0.0
var _guard_remaining := 0.0
var _guard_cooldown_remaining := 0.0


func _ready() -> void:
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.45
	capsule.height = 1.8
	var collision := CollisionShape3D.new()
	collision.shape = capsule
	add_child(collision)
	_add_shape(CapsuleMesh.new(), Vector3.ZERO, body_color, Vector3.ONE)
	var head := SphereMesh.new()
	head.radius = 0.37
	head.height = 0.70
	_add_shape(head, Vector3(0, 0.93, 0), body_color.lightened(0.16), Vector3.ONE)
	var visor := BoxMesh.new()
	visor.size = Vector3(0.50, 0.16, 0.12)
	_add_shape(visor, Vector3(0, 0.96, -0.34), Color(1.0, 0.90, 0.33), Vector3.ONE)
	for side in [-1, 1]:
		var arm := BoxMesh.new()
		arm.size = Vector3(0.24, 0.70, 0.30)
		_add_shape(arm, Vector3(float(side) * 0.58, 0.14, 0), body_color.darkened(0.25), Vector3.ONE)
	health_changed.emit(health, MAX_HEALTH)


func _add_shape(mesh: Mesh, offset: Vector3, tint: Color, scale_value: Vector3) -> void:
	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	visual.position = offset
	visual.scale = scale_value
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.metallic = 0.45
	material.roughness = 0.28
	visual.material_override = material
	add_child(visual)


func _physics_process(delta: float) -> void:
	if health == 0:
		return
	_cooldown = maxf(0.0, _cooldown - delta)
	_guard_remaining = maxf(0.0, _guard_remaining - delta)
	_guard_cooldown_remaining = maxf(0.0, _guard_cooldown_remaining - delta)
	var move_direction := Vector3.ZERO
	if player_controlled:
		var axis := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		move_direction = Vector3(axis.x, 0, axis.y).normalized()
		if Input.is_action_just_pressed("guard") and CombatRules.may_raise_guard(_guard_remaining, _guard_cooldown_remaining):
			_guard_remaining = GUARD_DURATION
			_guard_cooldown_remaining = GUARD_COOLDOWN
		if Input.is_action_just_pressed("attack"):
			_try_attack()
	elif is_instance_valid(opponent) and opponent.health > 0:
		var toward := opponent.global_position - global_position
		toward.y = 0.0
		if toward.length() > ATTACK_RANGE * 0.88:
			move_direction = toward.normalized()
		else:
			_try_attack()

	velocity.x = move_direction.x * WALK_SPEED
	velocity.z = move_direction.z * WALK_SPEED
	if not is_on_floor():
		velocity.y -= 19.0 * delta
	else:
		velocity.y = 0.0
	move_and_slide()
	global_position.x = clampf(global_position.x, -9.0, 9.0)
	global_position.z = clampf(global_position.z, -9.0, 9.0)
	if move_direction.length_squared() > 0.001:
		rotation.y = atan2(-move_direction.x, -move_direction.z)


func _try_attack() -> void:
	if _cooldown > 0.0 or _guard_remaining > 0.0 or not is_instance_valid(opponent) or opponent.health == 0:
		return
	var distance := global_position.distance_to(opponent.global_position)
	if not CombatRules.in_range(distance, ATTACK_RANGE):
		return
	_cooldown = 0.65
	opponent.receive_damage(16)


func receive_damage(base_damage: int) -> void:
	if health == 0:
		return
	health = CombatRules.remaining_health(health, CombatRules.guarded_damage(base_damage, 2, _guard_remaining > 0.0), MAX_HEALTH)
	health_changed.emit(health, MAX_HEALTH)
	if health == 0:
		defeated.emit()


func guard_status() -> String:
	if _guard_remaining > 0.0:
		return "ATIVO"
	if _guard_cooldown_remaining > 0.0:
		return "RECARGA %.1fs" % _guard_cooldown_remaining
	return "PRONTO"
