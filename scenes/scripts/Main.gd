extends Node2D


const GIFExporter = preload("res://gdgifexporter/exporter.gd")
const MedianCutQuantization = preload("res://gdgifexporter/quantization/median_cut.gd")
const GIF_RESOLUTION = Vector2(480, 270)
const GIF_FRAMES = 60


const LERP_WEIGHT = 0.1


var pos = 0
var total_scenes: int
var exporting = false


@onready var shader_scenes = get_children()


func _ready() -> void:
	total_scenes = len(shader_scenes)
	for i in range(total_scenes):
		shader_scenes[i].position = Vector2(1920, 0) * i


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left") and pos > 0:
		pos -= 1
	elif Input.is_action_just_pressed("ui_right") and pos < total_scenes - 1:
		pos += 1 
	elif Input.is_action_just_pressed("ui_accept") and not exporting:
		export_gif()


func _process(delta: float) -> void:
	position = lerp(position, Vector2(-1920, 0) * pos, LERP_WEIGHT)


func export_gif():
	exporting = true
	
	var exporter = GIFExporter.new(GIF_RESOLUTION[0], GIF_RESOLUTION[1])
	for i in range(GIF_FRAMES):
		var img = get_viewport().get_texture().get_image()
		img.resize(GIF_RESOLUTION[0], GIF_RESOLUTION[1])
		img.convert(Image.FORMAT_RGBA8)
		exporter.add_frame(img, 1.0 / 60.0, MedianCutQuantization)
		await get_tree().process_frame
	var file: FileAccess = FileAccess.open("user://" + shader_scenes[pos].name + ".gif", FileAccess.WRITE)
	file.store_buffer(exporter.export_file_data())
	file.close()
	
	exporting = false
