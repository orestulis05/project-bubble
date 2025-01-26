extends CharacterBody2D

const RESPAWN_TIME = 1.0

var movement = true

@onready var shooting_area_pivot: Node2D = $"Shooting Area Pivot"
@onready var shooting_area: Area2D = $"Shooting Area Pivot/Shooting Area"
@onready var shooting_collider: CollisionShape2D = $"Shooting Area Pivot/Shooting Area/CollisionShape2D"

@export var max_bubble_quantity : float = 100.0
@onready var bubble_quantity : float = max_bubble_quantity
@onready var initial_scale : Vector2 = scale
@export var bubble_decrease_rate : float = 0.3
var dynamic_color : Color = Color.WHITE

@onready var animated_sprite: AnimatedSprite2D = %animated_sprite
@onready var legs: Sprite2D = %legs
@onready var bubbles: GPUParticles2D = %bubbles

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var bullet_speed = 200.0
var stunned = false
var is_shooting = false
var shooting_input: Vector2

func _ready() -> void:
	shooting_collider.disabled = true
	bubbles.emitting = false

func _process(delta: float) -> void:
	
	# Color change
	var gb : float = bubble_quantity / max_bubble_quantity
	dynamic_color.g = gb
	dynamic_color.b = gb
	$animated_sprite.modulate = dynamic_color
	$legs.modulate = dynamic_color

	if Input.is_action_just_pressed("reload"):
		die()

func _physics_process(delta: float) -> void:
	
	if movement:
		_movement()
		_shooting()
	
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
	if bubble_quantity <= 40:
		die()
	
	if movement:
		move_and_slide()
	
func _movement():
	if is_shooting:
		var degrees = _calculated_shooting_angle(shooting_input)
		animated_sprite.rotation_degrees = degrees
		animated_sprite.animation = "blowing"
		legs.show()
		bubbles.emitting = true
	elif not is_on_floor():
		animated_sprite.rotation_degrees = 0
		legs.hide()
		bubbles.emitting = false
		animated_sprite.animation = "jumping"	
	elif (velocity.x > 1 || velocity.x < -1):
		animated_sprite.rotation_degrees = 0
		legs.hide()
		bubbles.emitting = false
		animated_sprite.animation = "running"
	else:
		animated_sprite.rotation_degrees = 0
		legs.hide()
		bubbles.emitting = false
		animated_sprite.animation = "idle"
	# Handle jump.
		
	if (!stunned):
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
			
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * speed
		else:
			if (is_shooting):
				velocity.x = move_toward(velocity.x, 0, speed)
			else:
				velocity.x = move_toward(velocity.x, 0, 20)
				
		var isLeft = velocity.x < 0
		animated_sprite.flip_h = isLeft
		
func _shooting():
	shooting_input = Vector2(Input.get_axis("shoot_left", "shoot_right"), Input.get_axis("shoot_up", "shoot_down"))
	
	if(!stunned):
		if shooting_input.length() != 0:
			is_shooting = true
			shooting_area_pivot.rotation_degrees = _calculated_shooting_angle(shooting_input)
			shooting_collider.disabled = false
			bubble_quantity -= bubble_decrease_rate
			scale = calculated_player_scale()
		else:
			legs.hide()
			is_shooting = false
			shooting_collider.disabled = true
		_shooting_movement(shooting_input)	

func _shooting_movement(shooting_input):
	if shooting_input.length() > 0:
		if shooting_input.y > 0:
			velocity.y = shooting_input.y * -speed
		elif shooting_input.y < 0:
			velocity.y += shooting_input.y * -speed * 0.3
		velocity.x += shooting_input.x * -speed

func calculated_player_scale() -> Vector2:
	var scaleMult : float = bubble_quantity / max_bubble_quantity
	var result = initial_scale * scaleMult
	return result

func _calculated_shooting_angle(input : Vector2) -> float:
	var dot : float
	var cosine : float
	var radians : float
	var degrees : float
	
	if input.y > 0:
		dot = input.dot(Vector2.RIGHT)
		cosine = dot / (input.normalized().length() * Vector2.RIGHT.length())
		radians = acos(cosine)
		degrees = rad_to_deg(radians)
	elif input.y < 0:
		dot = input.dot(Vector2.LEFT)
		cosine = dot / (input.normalized().length() * Vector2.LEFT.length())
		radians = acos(cosine)
		degrees = rad_to_deg(radians) + 180.0
	else:
		if input.x > 0:
			degrees = 0
		elif input.x < 0:
			degrees = 180
	
	if (input.x == 1 and input.y == 1):
		degrees = 45
	elif (input.x == 1 and input.y == -1):
		degrees = 315
	elif (input.x == -1 and input.y == 1):
		degrees = 135
	elif (input.x == -1 and input.y == -1):
		degrees = 225
	
	return degrees
	
func die():
	movement = false
	Globals.play_sound_random_pitch($SFX/Death_SFX, 0.8, 1.2)
	$Bubble_Explosion_Fx.emitting = true
	$animated_sprite.hide()
	$legs.hide()
	$"%bubbles".hide()
	await get_tree().create_timer(RESPAWN_TIME).timeout
	Globals.continue_game()
