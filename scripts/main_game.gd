extends Control

@onready var code_matrix: GridContainer = $"MainMargin/VBoxContainer/MainContent/Code Matrix"
@onready var memory_bar: HBoxContainer = $MainMargin/VBoxContainer/Header/MemoryBar
@onready var injection_list: VBoxContainer = $MainMargin/VBoxContainer/MainContent/InjectionList
@onready var timer_label: Label = $MainMargin/VBoxContainer/Header/TimerLabel

const cols: int = 5
const rows: int = 5
const tokens: Array[String] = ["1C", "BD", "55", "E9", "7A", "45","65", "D0"]

enum moveState { START, ROW, COL }
var current_state: moveState = moveState.START

var active_index: int = 0

var memory: Array[String] = []
var max_memory: int = 7

var injections: Array[Dictionary] = [
	{"name": "Alpha", "sequence": [], "reward": 3, "completed": false},
	{"name": "Beta", "sequence": [], "reward": 8, "completed": false},
	{"name": "Gamma", "sequence": [], "reward": 18, "completed": false}
]

var time_left: float = 30.0

var is_game_over: bool = false

func _ready() -> void:
	generate_buttons()
	generate_level()

func _process(delta: float) -> void:
	if is_game_over: return
	
	time_left -= delta
	
	if time_left <= 0:
		time_left = 0.0
		is_game_over = true
		print("GAMEOVER")
	
	update_timer_ui()

func update_timer_ui() -> void:
	var seconds = int(time_left)
	var miliseconds = int(fmod(time_left, 1.0) * 100)
	timer_label.text = "%02d:%02d" % [seconds, miliseconds]
	
	var tween = create_tween().set_parallel(true)
	if time_left <= 10.0:
		tween.tween_property(timer_label, "modulate", Color.RED, 2.0)
		tween.tween_property(timer_label, "scale", Vector2(1.3, 1.3), 2.0)
	else:
		tween.tween_property(timer_label, "modulate", Color.WHITE, 0.5)
		tween.tween_property(timer_label, "scale", Vector2(1, 1), 0.5)
	
	
func generate_level() -> void:
	var path_length: int = 6
	var path_cords: Array = []
	var master_sequence: Array = []
	
	var curr_row = 0
	var curr_col = randi() % cols
	path_cords.append(Vector2(curr_col, curr_row))
	
	var is_moving_col = true
	
	for i in range(1, path_length):
		if is_moving_col:
			var new_row = randi() % rows
			while new_row == curr_row:
				new_row = randi() % rows
			curr_row = new_row
		else:
			var new_col = randi() % cols
			while new_col == curr_col:
				new_col = randi() % cols
			curr_col = new_col
		
		path_cords.append(Vector2(curr_col, curr_row))
		is_moving_col = !is_moving_col
	
	for i in range(path_length):
		master_sequence.append(tokens.pick_random())
	
	injections[0]["sequence"] = master_sequence.slice(4,6)
	injections[1]["sequence"] = master_sequence.slice(0, 3)
	injections[2]["sequence"] = master_sequence.slice(2,5)
	
	update_injection_ui()
	
	var buttons = code_matrix.get_children()
	
	for i in range(buttons.size()):
		var btn = buttons[i] as Button
		var col = i % cols
		var row = int(i / cols)
		var current_pos = Vector2(col, row)
		
		var path_index = path_cords.find(current_pos)
		
		if path_index != -1:
			var token = master_sequence[path_index]
			btn.setup(token)
			btn.pressed.connect(_on_token_clicked.bind(btn, col, row, token))
		else:
			var token = tokens.pick_random()
			btn.setup(token)
			btn.pressed.connect(_on_token_clicked.bind(btn, col, row, token))
	
	print("--- CHEAT CODE ---")
	print(master_sequence)
	print(path_cords)
	print("----------------------------------")
	
func generate_injections() -> void:
	var lengths = [2, 3, 3]
	
	for i in range(injections.size()):
		var seq_length = lengths[i]
		var seq: Array[String] = []
		
		for j in range(seq_length):
			seq.append(tokens.pick_random())
		injections[i]["sequence"] = seq
	
	update_injection_ui()

func update_injection_ui() -> void:
	var labels = injection_list.get_children()
	for i in range(injections.size()):
		if i < labels.size():
			var inj = injections[i]
			var seq_string = " - ".join(inj["sequence"])
			var label = labels[i] as Label
			label.text = inj["name"] + " (" + str(inj["reward"]) + "s): " + seq_string
			
			if inj["completed"]:
				label.modulate = Color.GREEN_YELLOW


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
	
	if memory.size() < max_memory:
		memory.append(token)
		update_memory_ui()
		check_injections()
		
		if memory.size() >= max_memory:
			print("end")
			# TODO over
	
	update_visuals()

func update_memory_ui() -> void:
	for child in memory_bar.get_children():
		child.queue_free()
	

	
	for token in memory:
		var lbl = Label.new()
		lbl.text = "[" + token + "]"
		memory_bar.add_child(lbl)
	
	for i in range(max_memory - memory.size()):
		var rect = ColorRect.new()
		rect.color = Color.WHITE
		rect.custom_minimum_size = Vector2(40, 40)
		rect.custom_maximum_size = Vector2(40, 40)
		memory_bar.add_child(rect)

func check_injections() -> void:
	var successs_this_turn: bool = false
	
	for inj in injections:
		if inj["completed"]:
			continue
		
		if is_sub_array(memory, inj["sequence"]):
			inj["completed"] = true
			time_left += inj["reward"]
			successs_this_turn = true
			print("won: ", inj["name"])
			# TODO: global timer
	
	if successs_this_turn:
		update_injection_ui()


func is_sub_array(main_arr: Array, sub_arr: Array) -> bool:
	if sub_arr.size() == 0 or sub_arr.size() > main_arr.size(): return false
	
	for i in range(main_arr.size() - sub_arr.size() + 1):
		var is_match = true
		
		for j in range(sub_arr.size()):
			if main_arr[i + j] != sub_arr[j]:
				is_match = false
				break
		
		if is_match:
			return true
	return false

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
