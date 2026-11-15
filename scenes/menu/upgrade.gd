extends Control

@onready var title_label: Label = $TitleLabel
@onready var icon_texture_rect: TextureRect = $IconTextureRect
@onready var levels_container: HBoxContainer = $LevelsContainer
@onready var cost_label: Label = $CostLabel

var title: String = ""
var max_levels: int = 5
var current_level: int = 0
var texture: Texture2D
var cost: int = 0
var cost_multiplier: float = 1.0

func _ready() -> void:
	title_label.text = title
	icon_texture_rect.texture = texture
	cost_label.text = str(int(cost * (cost_multiplier ** current_level)))
	
	for child in levels_container.get_children():
		child.queue_free()
	
	for i in range(max_levels):
		var rect = ColorRect.new()
		rect.custom_maximum_size = Vector2(30,30)
		rect.custom_minimum_size = Vector2(30,30)
		
		if i < current_level:
			rect.color = Color("CBB9A8")
		else:
			rect.color = Color(0.3, 0.3, 0.3, 0.5)
			
		levels_container.add_child(rect)
	

func setup(new_title: String, new_max_levels:int, new_current_level: int, icon: Texture2D, new_cost: int, new_cost_multiplier: float ) -> void:
	title = new_title
	max_levels = new_max_levels
	current_level = new_current_level
	texture = icon
	cost = new_cost
	cost_multiplier = new_cost_multiplier
