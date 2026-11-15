extends Node

var layer: int = 1
var highest_layer: int = 0
var global_points: int = 0
var points_this_run: int = 0

var upgrades: Array[Dictionary] = [
	{
		"title" : "Additional 5s",
		"max_level" : 5,
		"current_level" : 5,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 5000,
		"cost_multiplier" : 2
	},
	{
		"title" : "+ 1.2 PTS Multiplier",
		"max_level" : 5,
		"current_level" : 3,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 25000,
		"cost_multiplier" : 1.3
	},
	{
		"title" : "Additional Memory",
		"max_level" : 2,
		"current_level" : 0,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 50000,
		"cost_multiplier" : 2.0
	}
]

func add_global_points(amount: int) -> void:
	global_points += amount

func add_points_this_run(amount: int) -> void:
	points_this_run += amount

func reset_points_this_run(amount: int) -> void:
	points_this_run = 0

func remove_global_points(amount: int) -> bool:
	if global_points - amount < 0:
		return false
	else:
		global_points -= amount
		return true

func reset_layer() -> void:
	layer = 0

func next_layer() -> void:
	layer += 1

func change_highest_layer() -> void:
	if layer > highest_layer: highest_layer = layer
