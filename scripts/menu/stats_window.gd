extends Control

@onready var points_label_score: Label = $MarginContainer/VBoxContainer/HBoxContainer/PointsLabelScore
@onready var layer_label_score: Label = $MarginContainer/VBoxContainer/HBoxContainer2/LayerLabelScore
@onready var top_run_points_score: Label = $MarginContainer/VBoxContainer/HBoxContainer3/TopRunPointsScore


var original_position: Vector2 = Vector2.ZERO
var shown: bool = false

func _ready() -> void:
	original_position = global_position
	points_label_score.text = "%09d" % Stats.global_points
	layer_label_score.text = "%02d" % Stats.highest_layer
	top_run_points_score.text = "%09d" % Stats.top_points

func close() -> void:
	if shown:
		var tween = create_tween()
		tween.tween_property(self, "global_position:y", original_position.y, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		shown = false

func _on_grab_mouse_entered() -> void:
	points_label_score.text = "%09d" % Stats.global_points
	shown = !shown
	var tween = create_tween()
	if shown:
		tween.tween_property(self, "global_position:y", original_position.y + 334.0, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	else:
		tween.tween_property(self, "global_position:y", original_position.y, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
