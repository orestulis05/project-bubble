extends CharacterBody2D

@onready var shooting_area_pivot: Node2D = $"Shooting Area Pivot"
@onready var shooting_area: Area2D = $"Shooting Area Pivot/Shooting Area"
@onready var shooting_collider: CollisionShape2D = $"Shooting Area Pivot/Shooting Area/CollisionShape2D"

@export var max_bubble_quantity : float = 100.0
@onready var bubble_quantity : float = max_bubble_quantity
@onready var initial_scale : Vector2 = scale
@export var bubble_decrease_rate : float = 0.5

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var bullet_speed = 200.0

func _ready() -> void:
	shooting_collider.disabled = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		Globals.continue_game()

func _physics_process(delta: float) -> void:
	_movement()
	_shooting()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Change color
	if bubble_quantity <= 50:
		$Rect.modulate = Color.RED
	if bubble_quantity <= 25:
		Globals.continue_game()
	
	move_and_slide()
	
func _movement():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
func _shooting():
	var shooting_input : Vector2 = Vector2(Input.get_axis("shoot_left", "shoot_right"), Input.get_axis("shoot_up", "shoot_down"))

	if shooting_input.length() != 0:
		shooting_area_pivot.rotation_degrees = _calculated_shooting_angle(shooting_input)
		shooting_collider.disabled = false
		bubble_quantity -= bubble_decrease_rate
		scale = _calculated_player_scale()
	else:
		shooting_collider.disabled = true
	_shooting_movement(shooting_input)	

func _shooting_movement(shooting_input):
	if shooting_input.length() > 0:
		if shooting_input.y > 0:
			velocity.y = shooting_input.y * -speed
		elif shooting_input.y < 0:
			velocity.y += shooting_input.y * -speed * 0.3
		velocity.x += shooting_input.x * -speed

func _calculated_player_scale() -> Vector2:
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
