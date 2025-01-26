extends RigidBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		var delta_y = position.y - body.position.y
		var delta_x = position.x - body.position.x
		if (delta_y > 30):
			body.velocity.y = body.jump_velocity * 1.5
		else:
			body.bubble_quantity -= 25
			body.scale = body.calculated_player_scale()
			_stunned(body)
			if (delta_x > 0):
				body.velocity.y = body.jump_velocity
				body.velocity.x = -body.speed * 0.75
			else:
				body.velocity.y = body.jump_velocity
				body.velocity.x = body.speed * 0.75

func _stunned(player):
	player.stunned = true
	await get_tree().create_timer(0.8).timeout
	player.stunned = false
