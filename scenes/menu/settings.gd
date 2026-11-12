extends Control

@onready var shader_check_box: CheckBox = $MarginContainer/VBoxContainer/HBoxContainer/shader_check_box


func _ready() -> void:
	shader_check_box.button_pressed = Settings.tv_shader_visible

func _process(delta: float) -> void:
	pass

func _on_shader_check_box_toggled(toggled_on: bool) -> void:
	Settings._change_tv_shader(toggled_on)
