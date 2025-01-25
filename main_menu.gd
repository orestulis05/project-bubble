extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/NewGame.grab_focus()

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://TestingMap.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Options.tscn")
