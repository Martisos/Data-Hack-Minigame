extends Control

@onready var grid_step_1: GridContainer = $MarginContainer/ScrollContainer/VBoxContainer/GridContainer
@onready var grid_step_2: GridContainer = $MarginContainer/ScrollContainer/VBoxContainer/GridContainer2

@onready var intro_label: Label = $MarginContainer/ScrollContainer/VBoxContainer/IntroLabel
@onready var step_1_label: Label = $MarginContainer/ScrollContainer/VBoxContainer/StepLabel
@onready var step_2_label: Label = $MarginContainer/ScrollContainer/VBoxContainer/StepLabel2
@onready var summary_label: Label = $MarginContainer/ScrollContainer/VBoxContainer/SummaryLabel



const TUTORIAL_TOKENS: Array[String] = [
	"55", "BD", "E9", "1C",
	"1C", "55", "7A", "BD",
	"BD", "7A", "1C", "55",
	"7A", "E9", "BD", "1C"
]

func _ready() -> void:
	build_tutorial_grid(grid_step_1, 1)
	build_tutorial_grid(grid_step_2, 2)

func build_tutorial_grid(grid: GridContainer, step: int) -> void:
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	
	for i in range(16):
		var col = i % 4
		var row = int(i / 4)
		var token = TUTORIAL_TOKENS[i]
		
		var cell = Label.new()
		cell.text = token
		cell.set("theme_override_font_sizes/font_size", 22)
		cell.custom_minimum_size = Vector2(44, 40)
		cell.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cell.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		var style = StyleBoxFlat.new()
		style.set_border_width_all(1)
		style.set_corner_radius_all(3)
		
		if step == 1:
			if row == 0:
				style.bg_color = Color("#0B4F6C")
				style.border_color = Color.CYAN
				cell.modulate = Color.WHITE
			else:
				style.bg_color = Color(0.08, 0.12, 0.2, 0.4)
				style.border_color = Color(0.2, 0.3, 0.4, 0.3)
				cell.modulate = Color(0.4, 0.4, 0.4, 0.5)
				
		elif step == 2:
			if row == 0 and col == 1:
				style.bg_color = Color(0.05, 0.05, 0.05, 0.7)
				style.border_color = Color(0.3, 0.3, 0.3, 0.5)
				cell.modulate = Color(0.3, 0.3, 0.3, 0.5)
			elif col == 1:
				style.bg_color = Color("#0B4F6C")
				style.border_color = Color.CYAN
				cell.modulate = Color.WHITE
			else:
				style.bg_color = Color(0.08, 0.12, 0.2, 0.4)
				style.border_color = Color(0.2, 0.3, 0.4, 0.3)
				cell.modulate = Color(0.4, 0.4, 0.4, 0.5)
				
		cell.add_theme_stylebox_override("normal", style)
		grid.add_child(cell)

func _on_back_button_pressed() -> void:
	Transition.change_scene("res://scenes/menu.tscn")
