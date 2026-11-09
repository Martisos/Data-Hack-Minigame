extends CanvasLayer
@onready var layer_label: Label = $LayerLabel


func update_level_ui() -> void:
	layer_label.text = "Layer - " + str(Stats.layer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
