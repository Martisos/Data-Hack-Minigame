extends Node

var layer: int = 1
var highest_layer: int = 0
var points: int = 0

func add_points(amount: int) -> void:
	points += amount

func remove_points(amount: int) -> bool:
	if points - amount < 0:
		return false
	else:
		points -= amount
		return true

func reset_layer() -> void:
	layer = 0

func next_layer() -> void:
	layer += 1

func change_highest_layer() -> void:
	if layer > highest_layer: highest_layer = layer
