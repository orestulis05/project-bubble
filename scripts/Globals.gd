extends Node



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
const SAVE_FILE_PATH : String = "user://save_file.tres"
var player_scene = preload("res://scenes/Player.tscn")

var current_checkpoint : int = 0

func save_game(current_scene_path, checkpoint_id):
	var save := SaveFile.new()
	save.last_scene_path = current_scene_path
	save.last_checkpoint_id = checkpoint_id
	ResourceSaver.save(save, SAVE_FILE_PATH)
	
func continue_game():
	var save : SaveFile = load(SAVE_FILE_PATH)
	get_tree().change_scene_to_file(save.last_scene_path)
	await get_tree().create_timer(0.1).timeout
	
	var player = get_tree().get_first_node_in_group("Player")
	
	var checkpoints = get_tree().get_nodes_in_group("Checkpoint")
	var spawn_pos : Vector2
	if checkpoints.size() != 0:
		spawn_pos = checkpoints[0].global_position
		for point in checkpoints:
			if point.checkpoint_id == save.last_checkpoint_id:
				print ("Nepraejo")
				current_checkpoint = save.last_checkpoint_id
				spawn_pos = point.global_position
	 
	player.global_position = spawn_pos
