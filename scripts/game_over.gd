extends Control

@onready var game_over_ui: Control = $GameOverUI

@onready var layer_label_text: Label = $GameOverUI/MarginContainer/VBoxContainer/HBoxContainer/LayerLabelText
@onready var layer_label_score: Label = $GameOverUI/MarginContainer/VBoxContainer/HBoxContainer/LayerLabelScore
@onready var points_label_text: Label = $GameOverUI/MarginContainer/VBoxContainer/HBoxContainer2/PointsLabelText
@onready var points_label_score: Label = $GameOverUI/MarginContainer/VBoxContainer/HBoxContainer2/PointsLabelScore
@onready var skull: TextureRect = $TextureRect

var skull_original_position: Vector2 = Vector2(100.0, 199.0)
var skull_start_position: Vector2 = Vector2(458.0, 199.0)

var points: int = Stats.points_this_run
var layer: int = Stats.layer
var best_layer: int = Stats.highest_layer

@onready var death_message: Label = $DeathMessage

var game_overs: Array[String] = [
	"You Failed. . .",
	"Game Over. . .",
	"You Got Caught.",
	"Not Again. . .",
	"Death Approaches.",
	"Back Again.",
	"Useless.",
	"Judgement Has Arrived.",
	"Too Weak.",
	"You Lost.",
	"Incompetent.",
	"You Are The Error.",
	"Again And Again.",
	"Really?",
	"Not Good Enough.",
	"Pathetic.",
	"Is That All?",
	"Wasted Effort",
	"Predictable.",
	"Skill Issue"
]

var second_message: Array[String] = [
	"Go And Try Again.",
	"But Do Not Give Up.",
	"Give Up.",
	"Stay Determined.",
	"Keep Trying.",
	"Quit.",
	"Begone.",
	"Fix Your Error.",
	"Why Not Try Harder?",
	"Learn From Your Mistakes",
	"Prove Me Wrong.",
	"Focus.",
	"Just ALT + F4",
	"Do Better.",
	"Maybe Do Something Easier?"
]

func _ready() -> void:
	game_over_ui.hide()
	skull.hide()
	skull.global_position = skull_start_position
	
	await starting_cutscene()
	await get_tree().create_timer(1).timeout
	
	show_ui_cutscene()

func starting_cutscene() -> void:
	death_message.text = ""
	death_message.show()
	await get_tree().create_timer(1).timeout
	var sentance: String = game_overs.pick_random()
	
	for i in sentance:
		death_message.text += i
		await get_tree().create_timer(0.15).timeout
	
	await get_tree().create_timer(1).timeout
	death_message.text = ""
	sentance = second_message.pick_random()
	
	for i in sentance:
		death_message.text += i
		await get_tree().create_timer(0.1).timeout

func fill_ui() -> void:
	
	points_label_score.text = "00"
	layer_label_score.text = "%09d" % 0
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_method(
		func(val: int): layer_label_score.text = "%02d" % val, 0, layer, 0.6
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_method(
		func(val: int): points_label_score.text = "%09d" % val, 0, points, 1.2
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func show_ui_cutscene() -> void:
	death_message.hide()
	skull.pivot_offset = skull.size / 2.0
	
	skull.global_position = skull_start_position
	skull.scale = Vector2(0.1, 0.1)
	skull.modulate = Color(2.0, 0.2, 0.2)
	skull.show()
	
	var tween = create_tween()
	tween.tween_property(skull, "scale", Vector2(10, 10), 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(skull, "modulate", Color.WHITE, 0.15)
	
	tween.tween_interval(0.5)
	
	tween.chain().tween_property(skull,"global_position", skull_original_position, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(skull, "scale", Vector2(5.0, 5.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.chain().tween_callback(reveal_game_ui)

func reveal_game_ui() -> void:
	game_over_ui.modulate.a = 0.0
	game_over_ui.show()
	
	var tween = create_tween()
	tween.tween_property(game_over_ui, "modulate:a", 1.0, 0.4)
	tween.chain().tween_callback(fill_ui)
