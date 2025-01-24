extends CharacterBody2D

@onready var shooting_area_pivot: Node2D = $"Shooting Area Pivot"
@onready var shooting_area: Area2D = $"Shooting Area Pivot/Shooting Area"
@onready var shooting_collider: CollisionShape2D = $"Shooting Area Pivot/Shooting Area/CollisionShape2D"

@export var max_bubble_quantity : float = 100.0
@onready var bubble_quantity : float = max_bubble_quantity
@onready var initial_scale : Vector2 = scale
@export var bubble_decrease_rate : float = 0.5

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const BULLET_SPEED = 200.0

func _ready() -> void:
	shooting_collider.disabled = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	_movement()
	_shooting()

	move_and_slide()
	
func _movement():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func _shooting():
	var shooting_input : Vector2 = Vector2(Input.get_axis("shoot_left", "shoot_right"), Input.get_axis("shoot_up", "shoot_down"))
	
	if shooting_input.length() != 0:
		shooting_collider.disabled = false
		if shooting_input == Vector2.RIGHT:
			shooting_area_pivot.rotation_degrees = 0
		if shooting_input == Vector2.DOWN:
			shooting_area_pivot.rotation_degrees = 90
		if shooting_input == Vector2.LEFT:
			shooting_area_pivot.rotation_degrees = 180
		if shooting_input == Vector2.UP:
			shooting_area_pivot.rotation_degrees = 270
		bubble_quantity -= bubble_decrease_rate
		#print(bubble_quantity)
		scale = _calculated_player_scale()
	else:
		shooting_collider.disabled = true
	_shooting_movement(shooting_input)	
		

func _shooting_movement(shooting_input):
	if shooting_input == Vector2.RIGHT:
		velocity.x += -SPEED
	if shooting_input == Vector2.LEFT:
		velocity.x += SPEED
	if shooting_input == Vector2.DOWN:
		velocity.y = JUMP_VELOCITY
	if shooting_input == Vector2.UP:
		velocity.y = -JUMP_VELOCITY

func _calculated_player_scale() -> Vector2:
	var scaleMult : float = bubble_quantity / max_bubble_quantity
	var result = initial_scale * scaleMult
	return result

