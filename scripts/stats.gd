extends Node

var layer: int = 1
var highest_layer: int = 0

func reset_layer() -> void:
	layer = 0

func next_layer() -> void:
	layer += 1

func change_highest_layer() -> void:
	if layer > highest_layer: highest_layer = layer
