extends Node2D


const LERP_WEIGHT = 0.1


var pos = 0
var total_scenes: int


func _ready() -> void:
	var shader_scenes = get_children()
	total_scenes = len(shader_scenes)
	for i in range(total_scenes):
		shader_scenes[i].position = Vector2(1920, 0) * i


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left") and pos > 0:
		pos -= 1
	elif Input.is_action_just_pressed("ui_right") and pos < total_scenes - 1:
		pos += 1 


func _process(delta: float) -> void:
	position = lerp(position, Vector2(-1920, 0) * pos, LERP_WEIGHT)
