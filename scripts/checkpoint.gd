extends Area2D

@export var checkpoint_id : int = 0

func _on_body_entered(body: Node2D) -> void:
	if Globals.current_checkpoint < checkpoint_id:
		Globals.save_game(get_tree().current_scene.scene_file_path, checkpoint_id)
		print("PYST")
		Globals.current_checkpoint = checkpoint_id
