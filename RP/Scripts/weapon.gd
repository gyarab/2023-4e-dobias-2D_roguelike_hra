extends Node2D

@onready var sprite = $Sprite2D

@onready var attackU = $Area2D/Up
@onready var attackD = $Area2D2/Down 
@onready var attackL = $Area2D3/Left
@onready var attackR = $Area2D4/Right

@onready var weapon_swing = $Weapon_swing

var attacked = false
var attacking = false
var attack_dur = 0.0
var attack_cld = 0.3 #cld == cooldown
var attack_cld_mem = attack_cld

var up_a = false
var down_a = false
var left_a = false
var right_a = false

	
func _physics_process(delta):
	sprite.set_visible(false)
	if Input.get_action_strength("Attack_up") == 1 and attacked == false and (down_a or left_a or right_a) != true:
		attackU.set_disabled(false)
		if attacking == false:
			sprite.rotate(-sprite.get_rotation() + 1.5)
		attacking = true
		up_a = true
		sprite.set_position(Vector2i(0, -15))
		sprite.rotate(0.2)
		sprite.set_visible(true)
	else:
		attackU.set_disabled(true)
		
	if Input.get_action_strength("Attack_down") == 1 and attacked == false and (up_a or left_a or right_a) != true:
		attackD.set_disabled(false)
		if attacking == false:
			sprite.rotate(-sprite.get_rotation() + 2)
		attacking = true
		down_a = true
		sprite.set_position(Vector2i(0, 15))
		sprite.rotate(-0.2)
		sprite.set_visible(true)
	else:
		attackD.set_disabled(true)
				
	if Input.get_action_strength("Attack_left") == 1 and attacked == false and (up_a or down_a or right_a) != true:
		attackL.set_disabled(false)
		if attacking == false:
			sprite.rotate(-sprite.get_rotation() + 3.5)
		attacking = true
		left_a = true
		sprite.set_position(Vector2i(-11, 0))
		sprite.rotate(-0.2)
		sprite.set_visible(true)
	else:
		attackL.set_disabled(true)
			
	if Input.get_action_strength("Attack_right") == 1 and attacked == false and (up_a or down_a or left_a) != true:
		attackR.set_disabled(false)
		if attacking == false:
			sprite.rotate(-sprite.get_rotation() - 3.5)
		attacking = true
		right_a = true
		sprite.set_position(Vector2i(11, 0))
		sprite.rotate(0.2)
		sprite.set_visible(true)
	else:
		attackR.set_disabled(true)
		
	if attacking == true:
		weapon_swing.play()
		attack_dur += delta
	
	if attack_dur >= 0.2:
		attacked = true
		attacking = false
		attack_dur = 0.0
		sprite.set_visible(false)
	
	if attacked == true:
		attack_cld -= delta
		
	if attack_cld <= 0.0:
		attacked = false
		attack_cld = attack_cld_mem
		up_a = false
		down_a = false
		left_a = false
		right_a = false

func _on_area_2d_5_body_exited(body):
	await get_tree().create_timer(1).timeout
	if attack_cld_mem != 0:
		attack_cld_mem -= 0.05
	print("a")
