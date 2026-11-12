extends Node

var tv_shader_visible: bool = true

func _change_tv_shader(state: bool) -> void:
	ShaderLayer.visible = state
