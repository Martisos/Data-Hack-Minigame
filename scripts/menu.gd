extends Control

@onready var play_button: Button = $Control/VBoxContainer/PlayButton
@onready var shop_button: Button = $Control/VBoxContainer/ShopButton
@onready var shop: Control = $Shop
@onready var settings: Control = $Settings
@onready var shader_layer: CanvasLayer = $ShaderLayer

enum Windows { NONE, SHOP, SETTINGS }
var current_window: Windows = Windows.NONE

var shop_original_x: float = 0.0
var settings_original_x: float = 0.0

var shop_tween: Tween
var settings_tween: Tween

func _ready() -> void:
	current_window = Windows.NONE
	shop.global_position = Vector2(1152, 10)
	shop_original_x = shop.global_position.x
	settings_original_x = settings.global_position.x

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_tutorial_button_pressed() -> void:
	print("tutorial")

func _on_shop_button_pressed() -> void:
	if current_window == Windows.SHOP:
		close_all_windows()
	else:
		open_shop()

func _on_options_button_pressed() -> void:
	if current_window == Windows.SETTINGS:
		close_all_windows()
	else:
		open_settings()

func open_shop() -> void:
	close_all_windows()
	current_window = Windows.SHOP
	
	if shop_tween: shop_tween.kill()
	shop_tween = create_tween()
	shop_tween.tween_property(shop, "position:x", shop_original_x - 300.0, 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func open_settings() -> void:
	close_all_windows()
	current_window = Windows.SETTINGS
	
	if settings_tween: settings_tween.kill()
	settings_tween = create_tween()
	settings_tween.tween_property(settings, "position:x", 15.0, 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func close_all_windows() -> void:
	current_window = Windows.NONE
	
	if shop_tween: shop_tween.kill()
	shop_tween = create_tween()
	shop_tween.tween_property(shop, "position:x", shop_original_x, 0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	if settings_tween: settings_tween.kill()
	settings_tween = create_tween()
	settings_tween.tween_property(settings, "position:x", settings_original_x, 0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
