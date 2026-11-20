extends Node
const SAVE_PATH = "user://save_data.json"

func _ready() -> void:
	load_game()

func save_game() -> void:
	var upgrades_data = {}
	for upgrade in Upgrades.upgrades:
		upgrades_data[upgrade["title"]] = upgrade["current_level"]
		
	var save_dict = {
		"global_points": Stats.global_points,
		"highest_layer": Stats.highest_layer,
		"top_points": Stats.top_points,
		"upgrades": upgrades_data
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_dict, "\t")
		file.store_string(json_string)
		file.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file: return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		return
		
	var data = json.get_data()
	
	Stats.global_points = data.get("global_points", 0)
	Stats.highest_layer = data.get("highest_layer", 1)
	Stats.top_points = data.get("top_points", 0)
	
	var saved_upgrades = data.get("upgrades", {})
	for upgrade in Upgrades.upgrades:
		var title = upgrade["title"]
		if saved_upgrades.has(title):
			upgrade["current_level"] = int(saved_upgrades[title])
	Upgrades.apply_upgrades()
