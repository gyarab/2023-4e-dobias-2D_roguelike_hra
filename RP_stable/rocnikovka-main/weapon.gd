extends Node2D

@onready var sprite = $Sprite2D

@onready var attack_up = $Area2D/Up
@onready var attack_down = $Area2D2/Down
@onready var attack_left = $Area2D3/Left
@onready var attack_right = $Area2D4/Right

var right = false
var left = false
var up = false
var down = false

func _process(delta):
	attack_direction()
	attack_zones()
#function to determine where to attack
func attack_direction():
	if Input.get_action_strength("Attack_right"):
		left = false
		right = true
		down = false
		up = false
		sprite.set_visible(true)
	elif Input.get_action_strength("Attack_up"):
		left = false
		right = false
		down = false
		up = true
		sprite.set_visible(true)
	elif Input.get_action_strength("Attack_left"):
		left = true
		right = false
		down = false
		up = false
		sprite.set_visible(true)
	elif Input.get_action_strength("Attack_down"):
		left = false
		right = false
		down = true
		up = false
		sprite.set_visible(true)
	else:
		left = false
		right = false
		down = false
		up = false
		sprite.set_visible(false)
		
#function to enable/disable attack zones acordingly to atack directions
func attack_zones():
	attack_up.set_disabled(!up)
	attack_down.set_disabled(!down)
	attack_left.set_disabled(!left)
	attack_right.set_disabled(!right)
	

	
	
	
