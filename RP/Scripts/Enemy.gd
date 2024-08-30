extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var hit_sound = $Hit_sound
@onready var death_sound = $Death_sound

var SPEED = 3
var chase = false
var player = null
var health = 2

func _physics_process(delta):
	if chase:
		position += (player.position - position).normalized() * SPEED #moves the enemy to the player location
	
func _process(delta):
	animated_sprite.play("default") # plays the enemy animation
	if player != null and (player.position - position).normalized().x > 0: #handles where the enemy faces
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	
	if(health == 0): #handles enemy death
		chase = false #stops movement
		death_sound.play() # plays death sound
		await get_tree().create_timer(0.5).timeout # waits for the death sound to finish playing
		queue_free() #despawns the enemy

func _on_area_2d_body_entered(body): # gets the location of the player 
	player = body
	chase = true

func _on_area_2d_body_exited(body):
	player = null
	chase = false

func _on_hb_area_shape_entered(area_rid, area, area_shape_index, local_shape_index): #handles hits
	health -= 1 #
	hit_sound.play()
