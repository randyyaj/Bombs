
extends Area2D

var is_glowing = false
var is_blowing = false
var counter = 0
var fuse_time = 1
var exploded = false
var stage
var sound_player
var animation_player
const IGNITION_TIME = 0.5
const EXPLOSION_TIME = 1

func _ready():
	sound_player = get_node("sprite/sound")
	animation_player = get_node("sprite/animation")
	stage = get_node('../')
	set_process(true)

func _process(delta):
	if (is_glowing):
		counter += delta

	if (counter > IGNITION_TIME && !exploded && !is_blowing):
		set_to_explode()

	if (counter > EXPLOSION_TIME && !exploded):
		explode()
		
func destroy():
	"""
	Prompts the replay screen then call the stage reset to clear all bomb instances
	"""
	#todo prompt replay	https://github.com/okamstudio/godot/wiki/tutorial_pause
	stage.show_replay_prompt()


func _input_event( viewport, event, shape_idx ):
	"""
	Function registers event handling
	"""
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.is_pressed()): #event.button_index == 1
			if (is_glowing):
				set_to_diffused()

func set_to_ignite():
	"""
	Function sets the bomb to ignite(yellow)
	"""
	if (!exploded):
		sound_player.play('lit')
		animation_player.play('ignite')
		is_glowing = true

func set_to_explode():
	"""
	Function sets bomb to explode (red)
	"""
	if (!exploded):
		is_blowing = true
		animation_player.play('glowing')

func set_to_diffused():
	"""
	Function sets the bomb to diffused (black)
	"""
	if (!exploded):
		sound_player.play('diffuse')
		animation_player.play('idle')
		is_glowing = false
		is_blowing = false
		stage.score_counter += 1
		stage.set_diffuse_score(stage.score_counter)
		counter = 0

func explode():
	"""
	Explode the bomb!
	"""
	exploded = true
	is_glowing = false
	animation_player.play('fx_explosion')
	stage.set_best_score(stage.score_counter)

