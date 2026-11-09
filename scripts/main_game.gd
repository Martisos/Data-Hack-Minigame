extends Control

@onready var code_matrix: GridContainer = $"MainMargin/VBoxContainer/MainContent/Code Matrix"
@onready var memory_bar: HBoxContainer = $MainMargin/VBoxContainer/Header/MemoryBar
@onready var injection_list: VBoxContainer = $MainMargin/VBoxContainer/MainContent/InjectionList
@onready var timer_label: Label = $MainMargin/VBoxContainer/Header/TimerLabel
@onready var level_ui: CanvasLayer = $LevelUI

const cols: int = 6
const rows: int = 6
const tokens: Array[String] = ["1C", "BD", "55", "E9", "7A", "45","65", "D0", "FF", "MT", "I0"]

enum moveState { START, ROW, COL }
var current_state: moveState = moveState.START

var active_index: int = 0

var memory: Array[String] = []
var max_memory: int = 7

var injections: Array[Dictionary] = [
	{"name": "Alpha", "sequence": [], "completed": false},
	{"name": "Beta", "sequence": [], "completed": false},
	{"name": "Gamma", "sequence": [], "completed": false}
]

var completed_injection_count: int = 0
var reward_tiers: Array[float] = [5.0, 10.0, 15.0]

var time_left: float = 30.0

var is_game_over: bool = false

var is_danger_mode: bool = false
var timer_tween: Tween

var path_length: int = 6

func _ready() -> void:
	code_matrix.columns = cols
	timer_label.pivot_offset = timer_label.size / 2
	generate_buttons()
	generate_level()
	update_memory_ui()
	level_ui.update_level_ui()
	update_visuals()

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
	
	if time_left <= 10.0 and !is_danger_mode:
		is_danger_mode = true
		start_danger_animation()
		
	elif time_left > 10.0 and is_danger_mode:
		is_danger_mode = false
		reset_danger_animation()


func start_danger_animation() -> void:
	if timer_tween:
		timer_tween.kill()
	timer_tween = create_tween().set_loops()
	
	timer_tween.tween_property(timer_label, "modulate", Color.RED, 0.5)
	#timer_tween.parallel().tween_property(timer_label, "scale", Vector2(1.5, 1.5), 1.5)

func reset_danger_animation() -> void:
	if timer_tween:
		timer_tween.kill()
	#timer_tween.parallel().tween_property(timer_label, "scale", Vector2(1.0, 1.0), 0.3)
	timer_label.modulate = Color.WHITE


func generate_level() -> void:
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
	
	
	var len_a = 3
	var len_b = 3
	var len_c = 2
	
	if path_length >= 7:
		len_b = 4 

	var start_a = randi() % (path_length - len_a + 1)
	var start_b = randi() % (path_length - len_b + 1)
	while start_b == start_a:
		start_b = randi() % (path_length - len_b + 1)
		
	var start_c = randi() % (path_length - len_c + 1)
	
	var seq_1 = master_sequence.slice(start_a, start_a + len_a)
	var seq_2 = master_sequence.slice(start_b, start_b + len_b)
	var seq_3 = master_sequence.slice(start_c, start_c + len_c)
	
	var generated_sequences = [seq_1, seq_2, seq_3]
	generated_sequences.shuffle()
	
	for i in range(injections.size()):
		injections[i]["sequence"] = generated_sequences[i]
	
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
			label.text = inj["name"] + ": " + seq_string
			
			if inj["completed"]:
				label.modulate = Color.GREEN_YELLOW



func generate_buttons() -> void:
	for i in range(36):
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
	
	update_visuals()
	check_round_end()

func update_memory_ui() -> void:
	for child in memory_bar.get_children():
		child.queue_free()
	
	for token in memory:
		var lbl = Label.new()
		lbl.text = token
		lbl.custom_minimum_size = Vector2(40, 40)
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.2, 0.2, 0.2)
		lbl.add_theme_stylebox_override("normal", style)
		
		memory_bar.add_child(lbl)
	
	for i in range(max_memory - memory.size()):
		var rect = ColorRect.new()
		rect.color = Color(0.4, 0.4, 0.4, 0.5)
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
			successs_this_turn = true
			
			var reward = reward_tiers[completed_injection_count]
			time_left += reward
			completed_injection_count += 1
			
			print("won: ", inj["name"])
	
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


func check_round_end() -> void:
	if is_game_over: return
	
	if completed_injection_count >= 3:
		print("3 done!")
		advance_to_next_layer()
		return
	
	var is_memory_full: bool = (memory.size() >= max_memory)
	var no_moves_left: bool = !has_valid_moves_left()
	
	if is_memory_full or no_moves_left:
		if completed_injection_count > 0:
			advance_to_next_layer()
		else:
			is_game_over = true
			print("GAME OVER - no moves")
	
func has_valid_moves_left() -> bool:
	var buttons = code_matrix.get_children()
	for i in range(buttons.size()):
		var btn = buttons[i] as Button
		if btn.is_used: continue
		
		var col = i % cols
		var row = int(i/cols)
		
		if current_state == moveState.START and row == 0:
			return true
		if current_state == moveState.ROW and row == active_index:
			return true
		if current_state == moveState.COL and col == active_index:
			return true
		
	return false
	
func advance_to_next_layer() -> void:
	
	Stats.layer += 1
	current_state = moveState.START
	active_index = 0
	memory.clear()
	completed_injection_count = 0
	change_rules()
	
	for inj in injections:
		inj["completed"] = false
	
	for lbl in injection_list.get_children():
		lbl.modulate = Color.WHITE
	
	var buttons = code_matrix.get_children()
	for btn in buttons:
		btn.is_used = false
		btn.disabled = false
		btn.modulate = Color.WHITE
		for conn in btn.pressed.get_connections():
			btn.pressed.disconnect(conn.callable)
	
	generate_level()
	update_memory_ui()
	update_visuals()
	
	if level_ui and level_ui.has_method("update_level_ui"):
		level_ui.update_level_ui()

func change_rules() -> void:
	if Stats.layer == 2:
		path_length = 7
		print("changed path length to 7")
		
	if Stats.layer == 4:
		path_length = 6
		max_memory = 6
		print("LAYER 4: Ograniczenie pamięci do 6 slotów!")

	if Stats.layer == 6:
		path_length = 5
		max_memory = 5
