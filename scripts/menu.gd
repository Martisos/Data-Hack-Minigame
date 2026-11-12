extends Control

@onready var play_button: Button = $Control/VBoxContainer/PlayButton
@onready var shop_button: Button = $Control/VBoxContainer/ShopButton

var getting_bigger: bool = true

func _ready() -> void:
	pass

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_tutorial_button_pressed() -> void:
	print("tutorial")

func _on_shop_button_pressed() -> void:
	print("shop")


func _on_options_button_pressed() -> void:
	print("options")
