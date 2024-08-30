extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var death_sound = $Death_sound
@onready var hit_sound = $Hit_sound

var speed = 200
var health = 15
var direction = Vector2(1, 1)
var hit_counter = 0
var stun_duration = 3.0
var stunned_timer = 0.0
var hit_detector = true
var stunned = false

func _process(delta):
	animated_sprite.play("default") #plays the animation

func _physics_process(delta):
	if hit_counter >= 7: # 7 == 5 ???? Whern the boss hits the wall five times, he gets stuned and th e player can attack him
		stunned_timer += delta
		stunned = true
		if stunned_timer >= stun_duration: #To get the boss moving again
			hit_counter = 0
			stunned_timer = 0.0
			stunned = false
		return
	else:
		velocity = direction.normalized() * speed
		move_and_slide() #built in function to handle movement
		
#functions to detect colisions with walls
func _on_up_body_entered(body):
	direction.y = randf_range(0.1, 0.9) #chooses ranmdom direction in the asumed angle 
	if hit_detector == true: #counts how many times has the boos hit a wall
		hit_counter += 1
	hit_detector = false
	
func _on_down_body_entered(body):
	direction.y = randf_range(-0.9, -0.1)
	if hit_detector == true:
		hit_counter += 1
	hit_detector = false

func _on_left_body_entered(body):
	direction.x = randf_range(0.1, 0.9)
	if hit_detector == true:
		hit_counter += 1
	hit_detector = false

func _on_right_body_entered(body):
	direction.x = randf_range(-0.9, -0.1)
	if hit_detector == true:
		hit_counter += 1
	hit_detector = false

func _on_up_body_exited(body):
	hit_detector = true
	
func _on_down_body_exited(body):
	hit_detector = true

func _on_left_body_exited(body):
	hit_detector = true

func _on_right_body_exited(body):
	hit_detector = true

func _on_hb_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if stunned == true: #Does not allow the boss to be hit when he is not stunned
		health -= 1
		hit_sound.play() #plays the hit sound
	if health == 0: #when the boss dies
		set_physics_process(false) #stops all movement of the boss
		death_sound.play() #plays death sound
		await get_tree().create_timer(0.5).timeout # waits for the death sound to finish playing
		get_tree().change_scene_to_file("res://Scenes/Menu_screens/Win_menu.tscn") #displays thewin screen
