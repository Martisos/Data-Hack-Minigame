extends Control

@onready var title_label: Label = $TitleLabel
@onready var icon_texture_rect: TextureRect = $IconTextureRect
@onready var levels_container: HBoxContainer = $LevelsContainer
@onready var cost_label: Label = $CostLabel
@onready var buy_button: Button = $BuyButton

var title: String = ""
var max_level: int = 5
var current_level: int = 0
var texture: Texture2D
var cost: int = 0
var cost_multiplier: float = 1.0
var is_disabled: bool = false

func _ready() -> void:
	title_label.text = title
	icon_texture_rect.texture = texture
	if current_level >= max_level:
		cost_label.text = ""
	else:
		cost_label.text = str(int(cost * (cost_multiplier ** current_level)))
	
	
	for child in levels_container.get_children():
		child.queue_free()
	
	for i in range(max_level):
		var rect = ColorRect.new()
		rect.custom_maximum_size = Vector2(30,30)
		rect.custom_minimum_size = Vector2(30,30)
		
		if i < current_level:
			rect.color = Color("CBB9A8")
		else:
			rect.color = Color(0.3, 0.3, 0.3, 0.5)
			
		levels_container.add_child(rect)
	update_ui()
	

func setup(new_title: String, new_max_level:int, new_current_level: int, icon: Texture2D, new_cost: int, new_cost_multiplier: float ) -> void:
	title = new_title
	max_level = new_max_level
	current_level = new_current_level
	texture = icon
	cost = new_cost
	cost_multiplier = new_cost_multiplier
	
	
	for upgrade in Upgrades.upgrades:
			if title == upgrade["title"]:
				is_disabled = upgrade.get("disabled", false)
				break

func get_current_cost() -> int:
	return int(cost * (cost_multiplier ** current_level))

func update_ui() -> void:
	
	if is_disabled:
		buy_button.text = "NOT IN DEMO"
		buy_button.disabled = true
		buy_button.modulate = Color.RED
		icon_texture_rect.modulate = Color(0.6, 0.6, 0.6, 0.8)
		return
	
	if current_level >= max_level:
		cost_label.text = ""
	else:
		cost_label.text = str(get_current_cost())
	
	var rects = levels_container.get_children()
	for i in range(rects.size()):
		var rect = rects[i] as ColorRect
		if i < current_level:
			rect.color = Color("CBB9A8")
		else:
			rect.color = Color(0.3, 0.3, 0.3, 0.5)

func _on_buy_button_pressed() -> void:
	
	if current_level >= max_level: return
	
	var current_cost = get_current_cost()
	
	if Stats.remove_global_points(current_cost):
		AudioManager.play_sfx(preload("uid://bpiduunv1b4ps"), 0.0, 0.1)
		for upgrade in Upgrades.upgrades:
			if title == upgrade["title"]:
				upgrade["current_level"] += 1
				current_level = upgrade["current_level"]
				animate_bought_rect(current_level - 1) 
				break
	
	Upgrades.apply_upgrades()
	update_ui()
	SaveSystem.save_game()

func animate_bought_rect(index: int) -> void:
	var rects = levels_container.get_children()
	if index >= 0 and index < rects.size():
		var rect = rects[index]
		var tween = create_tween()
		tween.tween_property(rect, "scale", Vector2(1.3, 1.3), 0.1)
		tween.tween_property(rect, "scale", Vector2(1.0, 1.0), 0.1)
