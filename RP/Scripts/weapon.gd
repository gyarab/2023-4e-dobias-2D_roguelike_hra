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
	
	#handles the attacks acording to the directions and cooldowns
	if Input.get_action_strength("Attack_up") == 1 and attacked == false and (down_a or left_a or right_a) != true: #makes sure that the player can attack
		attackU.set_disabled(false) #shows the direction where the playeris attacking
		if attacking == false: #resets the animation of attack
			sprite.rotate(-sprite.get_rotation() + 1.5)
		attacking = true
		up_a = true #disables the ability to attack in multiple directions
		sprite.set_position(Vector2i(0, -15)) #places the weapon in the corect spot
		sprite.rotate(0.2) #creates the attack animation
		sprite.set_visible(true) #makes the weapon visible
	else:
		attackU.set_disabled(true) #allows the attack in only one direction (on non visual level - in code)
		
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
		
	if attacking == true: #plays the attack sound during an attack and counts the attack duration
		weapon_swing.play() 
		attack_dur += delta
	
	if attack_dur >= 0.2: #starts the attack cooldown and disables the ability to attack
		attacked = true
		attacking = false
		attack_dur = 0.0
		sprite.set_visible(false)
	
	if attacked == true: #counts attack cooldown
		attack_cld -= delta
		
	if attack_cld <= 0.0: #allows attacking after the cooldown has passed
		attacked = false
		attack_cld = attack_cld_mem
		up_a = false
		down_a = false
		left_a = false
		right_a = false

func _on_area_2d_5_body_exited(body): #handles th e pickups of weapon scroll pickups
	await get_tree().create_timer(1).timeout
	if attack_cld_mem != 0: #makes sure the attack cooldown does not get to negative value
		attack_cld_mem -= 0.05 #shortens the attack cooldown
		attack_cld = attack_cld_mem
