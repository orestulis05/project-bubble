extends CharacterBody2D

const SPEED = 300.0
var direction_to_target : Vector2

enum AnglerStates{
	PATROLLING,
	ENRAGED
}

var state : AnglerStates = AnglerStates.PATROLLING

func _physics_process(delta: float) -> void:
	
	$Sprite.flip_h = true if velocity.x > 0 else false
	
	if state == AnglerStates.ENRAGED:
		velocity = direction_to_target * SPEED
		
		var c = get_slide_collision_count()
		if c > 0:
			queue_free()
		
	move_and_slide()

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if state == AnglerStates.PATROLLING:
		state = AnglerStates.ENRAGED
		direction_to_target = (body.global_position - global_position).normalized()
		$AnimationPlayer.play("raged")

func _on_kill_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("BAAAM")
		body.die()
