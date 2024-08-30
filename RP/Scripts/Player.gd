extends CharacterBody2D

const SPEED = 300.0
var health = 5
var health_start = health

@onready var health_bar = $HealthBar
@onready var animated_sprite = $AnimatedSprite2D
@onready var death_sound = $Death_sound
@onready var hurt_sound = $Hurt_sound

func _ready():
	health_bar.global_position = -(get_viewport().size/8) #places the health bar in the top left corner

func _physics_process(delta):
	var input_direction = Vector2( #handles inputs of movement
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
	
	velocity = input_direction.normalized() * SPEED
	move_and_slide() # handles movement
	
func _process(delta): # handles corect animations playing
	if Input.get_action_strength("Right"):
		animated_sprite.play("walk_right")
	elif Input.get_action_strength("Left"):
		animated_sprite.play("walk_left")
	elif Input.get_action_strength("Down"):
		animated_sprite.play("walk_down")
	elif Input.get_action_strength("Up"):
		animated_sprite.play("walk_up")
	else:
		animated_sprite.play("idle")
	
func _on_area_2d_body_entered(body): # code for displaying the corect amount of hearts when the player is hurt
	
	for i in range(health_start): #makes all the hearts invisible
		health_bar.get_child(i).set_visible(false)
		
	health -= 1 # "removes one heart"
	
	for i in range(health): # makes the correct amount of hearts visible
		health_bar.get_child(i).set_visible(true)
	
	hurt_sound.play() # plays the hurt sound
	
	if health == 0: #handles the player death
		death_sound.play() #plays the death sound
		await get_tree().create_timer(0.5).timeout #waits for the death sound to finish playing
		set_physics_process(false) #disables movement inputs
		get_tree().change_scene_to_file("res://Scenes/Menu_screens/Death_menu.tscn") #displays the death screen


func _on_pickup_range_body_exited(body): # handles picking up heart pickups
	await get_tree().create_timer(1).timeout
	if health < 5: #makes sure the player has less than 5 hearts
		health += 1 #adds heart
		
		#shows the corect number of hearts in the health bar
		for i in range(health_start):
			health_bar.get_child(i).set_visible(false)
		for i in range(health):
			health_bar.get_child(i).set_visible(true)
