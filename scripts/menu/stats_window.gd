extends Control

var original_position: Vector2 = Vector2.ZERO
var shown: bool = false

func _ready() -> void:
	original_position = global_position

func close() -> void:
	if shown:
		var tween = create_tween()
		tween.tween_property(self, "global_position:y", original_position.y, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		shown = false

func _on_grab_mouse_entered() -> void:
	print("yup")
	shown = !shown
	var tween = create_tween()
	if shown:
		tween.tween_property(self, "global_position:y", original_position.y + 334.0, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	else:
		tween.tween_property(self, "global_position:y", original_position.y, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
