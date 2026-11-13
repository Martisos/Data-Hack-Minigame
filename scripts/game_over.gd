extends Control

@onready var game_over_ui: Control = $GameOverUI

@onready var layer_label_text: Label = $GameOverUI/MarginContainer/VBoxContainer/HBoxContainer/LayerLabelText
@onready var layer_label_score: Label = $GameOverUI/MarginContainer/VBoxContainer/HBoxContainer/LayerLabelScore
@onready var points_label_text: Label = $GameOverUI/MarginContainer/VBoxContainer/HBoxContainer2/PointsLabelText
@onready var points_label_score: Label = $GameOverUI/MarginContainer/VBoxContainer/HBoxContainer2/PointsLabelScore

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
	"Again Here.",
	"Useless.",
	"Judgement Arrived.",
	"Too Weak.",
	"You Lost.",
	"Incompetent.",
	"You Are The Error.",
	"Again And Again.",
	"Really?",
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
	"Why Not Trying Harder?"
]

func _ready() -> void:
	#game_over_ui.hide()
	#starting_cutscene()
	fill_ui()

func starting_cutscene() -> void:
	death_message.text = ""
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
	points_label_score.text = "%09d" % points
	layer_label_score.text = "%02d" % layer
