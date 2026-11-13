extends CanvasLayer
@onready var layer_label: Label = $LayerLabel
@onready var points_label: Label = $PointsLabel

var displayed_points: int = 0
var score_tween: Tween

func update_level_ui() -> void:
	layer_label.text = "Layer - " + str(Stats.layer)
	
	if score_tween:
		score_tween.kill()
	
	score_tween = create_tween()
	score_tween.tween_method(set_points_text, displayed_points, Stats.points_this_run, 0.6
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func set_points_text(value: int) -> void:
	displayed_points = value
	points_label.text = "PTS: %09d" % value
