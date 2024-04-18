extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

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
	attack_animation()
#function to determine where to attack
func attack_direction():
	if Input.get_action_strength("Attack_right"):
		left = false
		right = true
		down = false
		up = false
	elif Input.get_action_strength("Attack_up"):
		left = false
		right = false
		down = false
		up = true
	elif Input.get_action_strength("Attack_left"):
		left = true
		right = false
		down = false
		up = false
	elif Input.get_action_strength("Attack_down"):
		left = false
		right = false
		down = true
		up = false
	else:
		left = false
		right = false
		down = false
		up = false
		
#function to enable/disable attack zones acordingly to atack directions
func attack_zones():
	attack_up.set_disabled(!up)
	attack_down.set_disabled(!down)
	attack_left.set_disabled(!left)
	attack_right.set_disabled(!right)
	
#function to play attack animation in the corect direction
func attack_animation():
	if right:
		animated_sprite.play("attack_h")
	elif left:
		animated_sprite.play("attack_h")
	elif up:
		animated_sprite.play("attack_v")
	elif down:
		animated_sprite.play("attack_v")
	else:
		animated_sprite.play("hold")
	
	
	
