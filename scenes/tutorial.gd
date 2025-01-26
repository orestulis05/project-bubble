extends Node2D

func _on_mushroom_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/Chapter2.tscn")
