extends Node3D

const Robot = preload("res://scripts/robot.gd")

var player: ArenaRobot
var enemy: ArenaRobot
var camera: Camera3D
var hud: Label
var outcome := ""


func _ready() -> void:
	_setup_controls()
	_build_arena()
	player = _make_robot("AZUL", Color(0.12, 0.84, 1.0), Vector3(-3, 1.0, 0), true)
	enemy = _make_robot("VERMELHO", Color(1.0, 0.22, 0.38), Vector3(3, 1.0, 0), false)
	player.opponent = enemy
	enemy.opponent = player
	player.health_changed.connect(_refresh_hud.unbind(2))
	enemy.health_changed.connect(_refresh_hud.unbind(2))
	player.defeated.connect(func(): outcome = "DERROTA — aperte R para reiniciar"; _refresh_hud())
	enemy.defeated.connect(func(): outcome = "VITORIA — aperte R para jogar de novo"; _refresh_hud())
	camera = Camera3D.new()
	camera.current = true
	camera.fov = 67.0
	add_child(camera)
	camera.global_position = Vector3(0, 13, 16)
	camera.look_at(Vector3.ZERO)
	var layer := CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(24, 18)
	hud.add_theme_font_size_override("font_size", 23)
	hud.add_theme_color_override("font_color", Color(0.92, 0.97, 1.0))
	layer.add_child(hud)
	_refresh_hud()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		return
	_refresh_hud()
	if not is_instance_valid(camera) or not is_instance_valid(player):
		return
	var destination := player.global_position + Vector3(0, 12, 15)
	camera.global_position = camera.global_position.lerp(destination, clampf(delta * 2.4, 0.0, 1.0))
	camera.look_at(player.global_position + Vector3(0, 0.3, 0))


func _make_robot(robot_name: String, tint: Color, start: Vector3, is_player: bool) -> ArenaRobot:
	var robot: ArenaRobot = Robot.new()
	robot.display_name = robot_name
	robot.body_color = tint
	robot.player_controlled = is_player
	robot.position = start
	add_child(robot)
	return robot


func _build_arena() -> void:
	var environment_node := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.025, 0.035, 0.08)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.28, 0.37, 0.65)
	environment_node.environment = environment
	add_child(environment_node)
	var sunlight := DirectionalLight3D.new()
	sunlight.rotation_degrees = Vector3(-55, -25, 0)
	sunlight.light_energy = 1.9
	add_child(sunlight)
	_add_box(Vector3(22, 0.8, 22), Vector3(0, -0.4, 0), Color(0.09, 0.12, 0.20))
	for offset in [-10.5, 10.5]:
		_add_box(Vector3(1.0, 2.5, 22), Vector3(offset, 1.25, 0), Color(0.05, 0.40, 0.55))
		_add_box(Vector3(22, 2.5, 1.0), Vector3(0, 1.25, offset), Color(0.05, 0.40, 0.55))
	_add_box(Vector3(0.12, 0.02, 19), Vector3(0, 0.03, 0), Color(0.17, 0.74, 0.98), false)


func _add_box(size: Vector3, pos: Vector3, tint: Color, solid: bool = true) -> void:
	var root: Node3D
	if solid:
		root = StaticBody3D.new()
	else:
		root = Node3D.new()
	root.position = pos
	add_child(root)
	var visual := MeshInstance3D.new()
	var cube := BoxMesh.new()
	cube.size = size
	visual.mesh = cube
	var mat := StandardMaterial3D.new()
	mat.albedo_color = tint
	mat.metallic = 0.15
	visual.material_override = mat
	root.add_child(visual)
	if solid:
		var shape := CollisionShape3D.new()
		var box_shape := BoxShape3D.new()
		box_shape.size = size
		shape.shape = box_shape
		root.add_child(shape)


func _refresh_hud() -> void:
	if not is_instance_valid(hud) or not is_instance_valid(player) or not is_instance_valid(enemy):
		return
	hud.text = "ROBOT ARENA DUEL  •  MVP\nAZUL  %d / 100       VERMELHO  %d / 100\nDEFESA: %s (B)   |   ESQUIVA: %s (SHIFT)\nWASD / setas: mover    ESPACO: atacar    R: reiniciar\n%s" % [player.health, enemy.health, player.guard_status(), player.dash_status(), outcome]


func _setup_controls() -> void:
	_bind_key("move_left", KEY_A)
	_bind_key("move_left", KEY_LEFT)
	_bind_key("move_right", KEY_D)
	_bind_key("move_right", KEY_RIGHT)
	_bind_key("move_up", KEY_W)
	_bind_key("move_up", KEY_UP)
	_bind_key("move_down", KEY_S)
	_bind_key("move_down", KEY_DOWN)
	_bind_key("attack", KEY_SPACE)
	_bind_key("guard", KEY_B)
	_bind_key("dash", KEY_SHIFT)
	_bind_key("restart", KEY_R)


func _bind_key(action: String, key: int) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var event := InputEventKey.new()
	event.physical_keycode = key
	InputMap.action_add_event(action, event)
