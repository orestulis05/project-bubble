extends Node

@onready var pause_panel: Panel = %PausePanel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var esc_pressed = Input.is_action_just_pressed("pause")
	if (esc_pressed == true):
		get_tree().paused = !get_tree().paused
		pause_panel.visible = !pause_panel.visible

func _on_button_pressed() -> void:
	pause_panel.hide()
	get_tree().paused = false


func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")
