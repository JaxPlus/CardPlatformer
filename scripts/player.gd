extends CharacterBody2D

@onready var game_menager: Node = %GameMenager
@onready var animated_sprite: AnimatedSprite2D = $Smoothing2D/AnimatedSprite2D
@onready var cards: HBoxContainer = %UI/BoxContainer/VBoxContainer/HBoxContainer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var restart_timer: Timer = $RestartTimer

@export var coyote_time: float = 0.08

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 500.0

var jump_avaiable = true

var skills = []
var card_scene = preload("res://scenes/card.tscn")

var can_doublejump = false
var can_teleport = false

var tween: Tween
var dash_velocity = 0.0

func _ready() -> void:
	skills = game_menager.player_skills
	
	for skill in skills:
		var temp = card_scene.instantiate()
		temp.set_meta("type", skill)
		cards.add_child(temp)

func _physics_process(delta: float) -> void:
	if GameMenager.is_scene_loading:
		return
	
	# Add the gravity.
	if not is_on_floor():
		if jump_avaiable:
			if coyote_timer.is_stopped():
				coyote_timer.start(coyote_time)
			#get_tree().create_timer(coyote_time).timeout.connect(coyote_timeout)
		
		velocity += get_gravity() * delta
	else:
		jump_avaiable = true
		coyote_timer.stop()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_avaiable:
		velocity.y = JUMP_VELOCITY
		jump_avaiable = false
		
	if !is_on_floor() and can_doublejump and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		can_doublejump = false

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	# Animations
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if Input.is_action_just_pressed("restart"):
		Engine.time_scale = 0.5
		get_node("CollisionShape2D").queue_free()
		restart_timer.start()
	
	use_dash()
	use_teleport()
	
	# Walking
	if direction:
		velocity.x = direction * (SPEED + dash_velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if !can_doublejump:
		if use_ability("double_jump", "ability_2"):
			can_doublejump = true

	move_and_slide()

func add_card(type: String):
	skills.append(type)
	
	var temp = card_scene.instantiate()
	temp.set_meta("type", type)
	cards.add_child(temp)

func use_ability(type: String, ability: StringName) -> bool:
	if Input.is_action_just_pressed(ability) and skills.find(type) != -1:
		skills.erase(type)

		for card in cards.get_children():
			if card.get_meta("type") == type:
				card.queue_free()
				break

		return true
	return false

func use_dash():
	if use_ability("dash", "ability_1"):
		dash_velocity = DASH_SPEED
		if tween:
			tween.stop()

		tween = create_tween()
		tween.tween_property(self, "dash_velocity", 0, 0.2).set_ease(Tween.EASE_OUT)

func use_teleport():
	if use_ability("teleport", "ability_3"):
		position = get_global_mouse_position()

func coyote_timeout():
	jump_avaiable = false


func _on_restart_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
