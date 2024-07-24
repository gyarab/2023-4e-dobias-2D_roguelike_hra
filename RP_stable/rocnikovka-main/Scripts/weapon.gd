extends Node2D

@onready var sprite = $Sprite2D

@onready var attack_u = $Area2D/Up
@onready var attack_d = $Area2D2/Down
@onready var attack_l = $Area2D3/Left
@onready var attack_r = $Area2D4/Right

var right = false
var left = false
var up = false
var down = false

var rotation_point = Vector2i(0,0)

func _process(delta):
	attack_direction()
	attack_zones()
	rotate_weapon()
	set_rotation_point()
	#attack_rotate()
	sprite.position = Vector2i(0, 0)
	
	
#function to determine where to attack
func attack_direction():
	if attack_right():
		left = false
		right = true
		down = false
		up = false
		sprite.set_visible(true)
	elif attack_up():
		left = false
		right = false
		down = false
		up = true
		sprite.set_visible(true)
	elif attack_left():
		left = true
		right = false
		down = false
		up = false
		sprite.set_visible(true)
	elif attack_down():
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

#easier attack input functions
func attack_left():
	return Input.get_action_strength("Attack_left")

func attack_right():
	return Input.get_action_strength("Attack_right")

func attack_down():
	return Input.get_action_strength("Attack_down")

func attack_up():
	return Input.get_action_strength("Attack_up")
		
#function to enable/disable attack zones acordingly to atack directions
func attack_zones():
	attack_u.set_disabled(!up)
	attack_d.set_disabled(!down)
	attack_l.set_disabled(!left)
	attack_r.set_disabled(!right)
	
#function to determine rotation point
func set_rotation_point():
	sprite.set_offset(rotation_point)
	if attack_up():
		rotation_point = Vector2i(-12, 12)
	elif attack_down():
		rotation_point = Vector2i(-12, 12)
	elif attack_left():
		rotation_point = Vector2i(-9, 9)
	elif attack_right():
		rotation_point = Vector2i(-9, 9)
	
#function to rotate the weapon sprite
func rotate_weapon():
	if attack_up():
		sprite.set_rotation(0.75*PI)
	elif attack_left():
		sprite.set_rotation(0.25*PI)
	elif attack_down():
		sprite.set_rotation(1.75*PI)
	elif attack_right():
		sprite.set_rotation(1.25*PI)
	else:
		sprite.set_rotation(-sprite.get_rotation())
	
#function to rotate weapon during attack
func attack_rotate():
	if attack_down() or attack_left() or attack_right() or attack_up():
		sprite.set_rotation_degrees(10)
