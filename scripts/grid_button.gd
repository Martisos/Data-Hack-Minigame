extends Button

var is_used: bool = false
@export var token_value: String

func setup(value: String) -> void:
	token_value = value
	text = token_value

func _ready() -> void:
	text = token_value
