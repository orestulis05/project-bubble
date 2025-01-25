class_name Checkpoint
extends Area2D

@export var checkpoint_id : int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("If ", Globals.current_checkpoint, " < ", checkpoint_id)
	if Globals.current_checkpoint < checkpoint_id:
		Globals.save_game(get_tree().current_scene.scene_file_path, checkpoint_id)
		print("Checkpoint ", checkpoint_id)
		Globals.current_checkpoint = checkpoint_id
