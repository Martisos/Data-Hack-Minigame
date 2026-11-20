extends Control

@onready var play_button: Button = $Control/VBoxContainer/PlayButton
@onready var shop_button: Button = $Control/VBoxContainer/ShopButton
@onready var shop: Control = $Shop
@onready var settings: Control = $Settings
@onready var stats_window: Control = $StatsWindow
@onready var tutorial: Control = $Tutorial

enum Windows { NONE, SHOP, SETTINGS, TUTORIAL }
var current_window: Windows = Windows.NONE

var shop_original_x: float = 0.0
var settings_original_x: float = 0.0
var tutorial_original_y: float = 0.0

var shop_tween: Tween
var settings_tween: Tween
var tutorial_tween: Tween

func _ready() -> void:
	current_window = Windows.NONE
	shop.global_position = Vector2(1152, 10)
	shop_original_x = shop.global_position.x
	settings_original_x = settings.global_position.x
	tutorial_original_y = tutorial.global_position.y
	AudioManager.play_music(preload("uid://b87kylwlgmj85"))

func _on_play_button_pressed() -> void:
	Transition.change_scene("res://scenes/main_game.tscn")

func _on_tutorial_button_pressed() -> void:
	AudioManager.play_sfx(preload("uid://b3lvp3hvo61dv"), -0.2, 0.1)
	if current_window == Windows.TUTORIAL:
		close_all_windows()
	else:
		open_tutorial()

func open_tutorial() -> void:
	close_all_windows()
	stats_window.close()
	current_window = Windows.TUTORIAL
	
	if tutorial_tween: tutorial_tween.kill()
	tutorial_tween = create_tween()
	tutorial_tween.tween_property(tutorial, "position:y", tutorial_original_y - 650.0, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _on_shop_button_pressed() -> void:
	AudioManager.play_sfx(preload("uid://b3lvp3hvo61dv"), 0.2, 0.1)
	if current_window == Windows.SHOP:
		close_all_windows()
	else:
		open_shop()

func _on_options_button_pressed() -> void:
	AudioManager.play_sfx(preload("uid://b3lvp3hvo61dv"), -0.2, 0.1)
	if current_window == Windows.SETTINGS:
		close_all_windows()
	else:
		open_settings()

func open_shop() -> void:
	close_all_windows()
	current_window = Windows.SHOP
	
	if shop_tween: shop_tween.kill()
	shop_tween = create_tween()
	shop_tween.tween_property(shop, "position:x", shop_original_x - 360.0, 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func open_settings() -> void:
	close_all_windows()
	stats_window.close()
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
	
	if tutorial_tween: tutorial_tween.kill()
	tutorial_tween = create_tween()
	tutorial_tween.tween_property(tutorial, "position:y", tutorial_original_y, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)	
