extends Control

@onready var play_button: Button = $Control/VBoxContainer/PlayButton
@onready var shop_button: Button = $Control/VBoxContainer/ShopButton




func _on_play_button_pressed() -> void:
	print("play")


func _on_shop_button_pressed() -> void:
	print("shop")


func _on_options_button_pressed() -> void:
	print("options")
