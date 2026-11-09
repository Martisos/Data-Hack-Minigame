extends Control

@onready var code_matrix: GridContainer = $"MainMargin/VBoxContainer/MainContent/Code Matrix"
@onready var memory_bar: HBoxContainer = $MainMargin/VBoxContainer/Header/MemoryBar

const cols: int = 5
const rows: int = 5
const tokens: Array[String] = ["1C", "BD", "55", "E9", "7A", "45","65", "D0"]

enum moveState { START, ROW, COL }
var current_state: moveState = moveState.START

var active_index: int = 0

func _ready() -> void:
	generate_buttons()
	setup_matrix()

func generate_buttons() -> void:
	for i in range(25):
		create_button("")
	pass

func setup_matrix() -> void:
	var buttons = code_matrix.get_children()
	
	for i in range(buttons.size()):
		var btn = buttons[i] as Button
		var col = i % cols
		var row = int(i / cols)
		var token = tokens.pick_random()
		btn.setup(token)
		
		btn.pressed.connect(_on_token_clicked.bind(btn, col, row, token))

func create_button(value: String) -> void:
	const button_scene = preload("uid://bqach0aipqa2d")
	var new_button = button_scene.instantiate()
	new_button.setup(value)
	
	code_matrix.add_child(new_button)



func _on_token_clicked(btn: Button, col: int, row: int, token: String) -> void:
	if current_state == moveState.START and row != 0: return
	if current_state == moveState.ROW and row != active_index: return
	if current_state == moveState.COL and col != active_index: return
	
	btn.is_used = true
	btn.disabled = true
	btn.modulate = Color(0.3, 0.3, 0.3, 0.5)
	print(row," ", col, " ",token)
	
	if current_state == moveState.START or current_state == moveState.ROW:
		current_state = moveState.COL
		active_index = col
	else:
		current_state = moveState.ROW
		active_index = row
	
	update_visuals()

func update_visuals() -> void:
	var buttons = code_matrix.get_children()
	
	for i in range(buttons.size()):
		var btn = buttons[i] as Button
		
		if btn.is_used:
			continue
		
		var col = i % cols
		var row = int(i / cols)
		
		var is_valid_move: bool = false
		
		match current_state:
			moveState.START:
				is_valid_move = (row == 0)
			moveState.ROW:
				is_valid_move = (row == active_index)
			moveState.COL:
				is_valid_move = (col == active_index)
				
		btn.disabled = !is_valid_move
		
		if is_valid_move:
			btn.modulate = Color.WHITE
		else:
			btn.modulate = Color(0.75, 0.75, 0.75, 0.75)
