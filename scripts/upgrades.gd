extends Node

func _ready() -> void:
	apply_upgrades()

var upgrades: Array[Dictionary] = [
	{
		"title" : "Additional 5s",
		"max_level" : 5,
		"current_level" : 0,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 5000,
		"cost_multiplier" : 2,
		"disabled" : false,
	},
	{
		"title" : "Additional Bonus 1s",
		"max_level" : 3,
		"current_level" : 0,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 75000,
		"cost_multiplier" : 1.4,
		"disabled" : false,
	},
	{
		"title" : "+ 1.2 PTS Multiplier",
		"max_level" : 5,
		"current_level" : 0,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 25000,
		"cost_multiplier" : 1.3,
		"disabled" : false,
	},
	{
		"title" : "Additional Memory",
		"max_level" : 2,
		"current_level" : 0,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 50000,
		"cost_multiplier" : 2.0,
		"disabled" : false,
	},
	{
		"title" : "Emergency Reboot",
		"max_level" : 1,
		"current_level" : 0,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 0,
		"cost_multiplier" : 2.0,
		"disabled" : true,
	},
	{
		"title" : "Signal Decryptor",
		"max_level" : 2,
		"current_level" : 0,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 0,
		"cost_multiplier" : 2.0,
		"disabled" : true,
	},
	{
		"title" : "CTRL + Z",
		"max_level" : 3,
		"current_level" : 0,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 0,
		"cost_multiplier" : 2.0,
		"disabled" : true,
	}
	,
	{
		"title" : "Show Me The Path",
		"max_level" : 3,
		"current_level" : 0,
		"icon" : preload("uid://c1syjbms8er6r"),
		"cost" : 0,
		"cost_multiplier" : 2.0,
		"disabled" : true,
	}
]

var additional_seconds: int = 0
var additional_bonus_seconds: int = 0
var additional_memory: int = 0
var additional_multiplier: float = 1.0

func apply_upgrades() -> void:
	additional_seconds = 0
	additional_bonus_seconds = 0
	additional_memory = 0
	additional_multiplier = 1.0

	for upgrade in upgrades:
		match upgrade["title"]:
			"Additional 5s":
				additional_seconds += 5 * upgrade["current_level"]
			"+ 1.2 PTS Multiplier":
				additional_multiplier += 0.2 * upgrade["current_level"]
			"Additional Memory":
				additional_memory += 1 * upgrade["current_level"]
			"Additional Bonus 1s":
				additional_bonus_seconds += 1 * upgrade["current_level"]
			
