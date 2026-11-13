extends CanvasLayer
@onready var layer_label: Label = $LayerLabel
@onready var points_label: Label = $PointsLabel

var displayed_points: int = 0

func update_level_ui() -> void:
	layer_label.text = "Layer - " + str(Stats.layer)
	points_label.text = "PTS: %09d" % Stats.points_this_run
	displayed_points = Stats.points_this_run

func _process(delta: float) -> void:
	pass
