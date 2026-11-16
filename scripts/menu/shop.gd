extends Control

var aviable_upgrades: Array[Dictionary] = Upgrades.upgrades
var upgrade_path: PackedScene = preload("uid://pr15nvxtx1lb")

@onready var v_box_container: VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer

func _ready() -> void:
	for upgrade in aviable_upgrades:
		var new_upgrade = upgrade_path.instantiate()
		new_upgrade.setup(
			upgrade["title"],
			upgrade["max_level"],
			upgrade["current_level"],
			upgrade["icon"],
			upgrade["cost"],
			upgrade["cost_multiplier"]
			)
		v_box_container.add_child(new_upgrade)
