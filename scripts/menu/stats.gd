extends Node

signal global_points_changed

var layer: int = 1
var highest_layer: int = 0
var global_points: int = 0
var points_this_run: int = 0
var top_points: int = 0


func add_global_points(amount: int) -> void:
	global_points += amount
	global_points_changed.emit()

func add_points_this_run(amount: int) -> void:
	points_this_run += amount

func reset_points_this_run(amount: int) -> void:
	points_this_run = 0

func remove_global_points(amount: int) -> bool:
	if global_points - amount < 0:
		return false
	else:
		global_points -= amount
		global_points_changed.emit()
		return true

func reset_layer() -> void:
	layer = 0

func next_layer() -> void:
	layer += 1

func change_highest_layer(number: int) -> void:
	if number > highest_layer: highest_layer = number

func set_top_points(amount: int) -> void:
	top_points = amount
