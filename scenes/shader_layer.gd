extends CanvasLayer
@onready var tv_shader: ColorRect = $TVShader

func _ready() -> void:
	tv_shader.hide()
	if Settings.tv_shader_visible:
		tv_shader.show()

func show_shader() -> void:
	tv_shader.show()

func hide_shader() -> void:
	tv_shader.hide()
