extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = %Sprite2D

const  SPEED = 300.00
var travel_direction: Vector2
var last_player_pos : Vector2

enum SharkStates{
	PATROLLING,
	ENRAGED
}

var player

var state = SharkStates.PATROLLING
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var colliding_player : bool
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			colliding_player = true
	
	$Sprite2D.flip_h = true if velocity.x > 0 else false
		
	if state == SharkStates.ENRAGED:
		sprite_2d.animation = "evil"
		velocity = travel_direction * SPEED
		var distance = (last_player_pos - global_position).length()
		if distance <= 5:
			if colliding_player:
				last_player_pos = player.global_position
				travel_direction = (last_player_pos - global_position).normalized()
				
			else:		
				state = SharkStates.PATROLLING
				velocity = Vector2.ZERO
	else:
		sprite_2d.animation = "chill"
		
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		if state == SharkStates.PATROLLING:
			state = SharkStates.ENRAGED
			last_player_pos = body.global_position
			travel_direction = (last_player_pos - global_position).normalized()
			
	
	
	


func _on_kill_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
