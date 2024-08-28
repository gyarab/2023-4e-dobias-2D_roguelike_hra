extends CharacterBody2D

const SPEED = 300.0
var health = 5

@onready var health_bar = $HealthBar
@onready var animated_sprite = $AnimatedSprite2D
@onready var death_sound = $Death_sound
@onready var hurt_sound = $Hurt_sound

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
	
	velocity = input_direction.normalized() * SPEED
	move_and_slide()
	
func _process(delta):
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
	
func _on_area_2d_body_entered(body):
	health -= 1
	health_bar.value = health * 33
	hurt_sound.play()
	if health == 0:
		death_sound.play()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/Start_menu.tscn")
