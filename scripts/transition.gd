extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.modulate.a = 0.0
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func change_scene(target_scene) -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP

	var fade_in = create_tween()
	fade_in.tween_property(color_rect, "modulate:a", 1.0, 0.2)
	await fade_in.finished
	
	ShaderLayer.hide()
	
	await get_tree().create_timer(0.5).timeout
	
	if target_scene is PackedScene:
		get_tree().change_scene_to_packed(target_scene)
	elif target_scene is String:
		get_tree().change_scene_to_file(target_scene)
		
	await get_tree().process_frame
	
	if Settings.tv_shader_visible:
		ShaderLayer.show()
	
	var fade_out = create_tween()
	fade_out.tween_property(color_rect, "modulate:a", 0.0, 0.2)
	await fade_out.finished
	
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
