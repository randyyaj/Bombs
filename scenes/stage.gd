
extends Node2D

const BOMB_AMOUNT = 12
var save_file = "user://save.data"
var f
var playing
var timer_counter = 0
var score_counter = 0
var best_score = 0
var random_pick = 0
var last_picked = 0
var best_score_label
var diffuse_score_label
var bomb = preload("res://scenes/bomb.xscn")
var bombs = []
var positions = [Vector2(65,50),
				Vector2(205,50),
				Vector2(355, 50),
				
				Vector2(65,190),
				Vector2(205,190),
				Vector2(355, 190),
				
				Vector2(65,330),
				Vector2(205,330),
				Vector2(355, 330),
				
				Vector2(65,470),
				Vector2(205,470),
				Vector2(355, 470)
				]

func _ready():
	f = File.new()
	playing = false
	best_score_label = get_node('label_container/VBoxContainer/best_score_label_container/best_score_amount')
	diffuse_score_label = get_node('label_container/VBoxContainer/diffuse_label_container/diffuse_amount')
	reset()
	load_data()
	set_process(true)
	set_process_input(true)

func _input(event):
	if (event.type==InputEvent.MOUSE_BUTTON || event.type==InputEvent.SCREEN_TOUCH) && event.is_pressed() && !playing:
		playing = true
		set_process(true)
		get_node("finger_tap/animation").stop_all()
		get_node("finger_tap").hide()

func _process(delta):
	if (!playing):
		set_process(false)
		get_node("finger_tap/animation").play("finger_tap")
	else:
		timer_counter += delta
		if (timer_counter > 0.5):
			timer_counter = 0
			ignite_bombs(delta)

func load_data():
	if f.file_exists(save_file): 
		f.open(save_file, File.READ) 
		if f.is_open(): 
			best_score = f.get_var()
			print("Data loaded.")
			f.close()
			best_score_label.set_text(str(best_score))
		else: 
			print("Unable to read file!")
	else:
		print("File does not exist.")
		f.open(save_file,File.WRITE) 
		f.store_var(best_score) 
		f.close()

func save_data():
	f.open(save_file, File.WRITE)
	f.store_var(best_score)
	f.close() 

func reset():
	"""
	Function resets the stage removes all exisiting child and readds them.
	"""
	if (bombs.size() > 0):
		print(bombs.size())
		for i in range(bombs.size()):
			remove_child(bombs[i])
			bombs[i].queue_free()
		bombs.resize(0)
	
	for i in range(BOMB_AMOUNT):
		var child = bomb.instance()
		child.set_pos(positions[i])
		bombs.append(child)
		add_child(bombs[i])
	
	score_counter = 0
	set_diffuse_score(score_counter)

func ignite_bombs(delta):
	"""
	Function that randomly selects a bomb to ignite
	"""
	randomize()
	random_pick = randi() % bombs.size() 
	
	if (random_pick != last_picked):
		bombs[random_pick].set_to_ignite()
	
	last_picked = random_pick
	
func set_diffuse_score(score):
	"""
	Setter function to set the diffuse score label
	@param score the score to set to
	"""
	diffuse_score_label.set_text(str(score))
	
func set_best_score(score):
	"""
	Setter function to set the best score label
	@param score the score to set to
	"""
	if (score > best_score):
		best_score = score
		best_score_label.set_text(str(score))
		save_data()
		
func show_replay_prompt():
	get_tree().set_pause(true)
	get_node('replay_button').show()

func _on_replay_button_pressed():
	reset()
	get_node('replay_button').hide()
	get_tree().set_pause(false)
