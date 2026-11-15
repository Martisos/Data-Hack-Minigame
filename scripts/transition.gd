extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var status_label: Label = $StatusLabel

func _ready() -> void:
	color_rect.modulate.a = 0.0
	status_label.modulate.a = 0.0
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func change_scene(target_scene) -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var loading_texts = [
		"> ACCESSING MAINFRAME...",
		"> REBOOTING NODE...",
		"> BYPASSING FIREWALL...",
		"> INITIALIZING PROTOCOL...",
		"> BOOTING UP SYSTEM...",
		"> 01001000 01101001...",
		"> DECRYPTING SECURE CHANNELS...",
		"> DEPLOYING NEURAL LINK...",
		"> ROOT ACCESS GRANTED...",
		"> COMPILING CACHE...",
		"> MOUNTING VIRTUAL DISK...",
		"> ESTABLISHING SECURE SOCKET...",
		"> MARTISOS.ITCH.IO",
		"> ALLOCATING MEMORY BLOCKS...",
		"> RECONNECTING WITH SERVERS..."
	]
	status_label.text = loading_texts.pick_random()

	var fade_in = create_tween().set_parallel(true)
	fade_in.tween_property(color_rect, "modulate:a", 1.0, 0.15).set_trans(Tween.TRANS_QUAD)
	fade_in.tween_property(status_label, "modulate:a", 1.0, 0.15)
	await fade_in.finished
	
	if has_node("/root/ShaderLayer"):
		ShaderLayer.hide()
	
	await get_tree().create_timer(0.4).timeout
	
	if target_scene is PackedScene:
		get_tree().change_scene_to_packed(target_scene)
	elif target_scene is String:
		get_tree().change_scene_to_file(target_scene)
		
	await get_tree().process_frame
	
	print(Settings.tv_shader_visible)
	if has_node("/root/ShaderLayer") and Settings.tv_shader_visible:
		ShaderLayer.show()
	
	var fade_out = create_tween().set_parallel(true)
	fade_out.tween_property(color_rect, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_CUBIC)
	fade_out.tween_property(status_label, "modulate:a", 0.0, 0.1)
	await fade_out.finished
	
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
