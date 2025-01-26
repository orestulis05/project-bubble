extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$NewGame.grab_focus()

func _on_new_game_pressed() -> void:
	var save := SaveFile.new()
	save.last_scene_path = "res://scenes/TestingMap.tscn"
	save.last_checkpoint_id = 0
	ResourceSaver.save(save, Globals.SAVE_FILE_PATH)
	Globals.continue_game()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Options.tscn")


func _on_continue_pressed() -> void:
	Globals.continue_game()
