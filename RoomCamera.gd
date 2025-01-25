extends Camera2D

@onready var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height")

var width_index = 0
var height_index = 0

func _physics_process(delta):
	
	width_index =  %Player.global_position.x / float(SCREEN_WIDTH)
	height_index = %Player.global_position.y / float(SCREEN_HEIGHT)
	
	width_index = floor(width_index)
	height_index = ceil(height_index)
	
	offset.x = SCREEN_WIDTH * width_index
	offset.y = SCREEN_HEIGHT * height_index
