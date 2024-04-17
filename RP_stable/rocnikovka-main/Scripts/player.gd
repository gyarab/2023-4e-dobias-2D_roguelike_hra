extends CharacterBody2D

const SPEED = 300.0
var health = 3

@onready var health_bar = $HealthBar

func _physics_process(delta):
	
	if health == 0:
		print("ded")
	
	var input_direction = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
	
	velocity = input_direction.normalized() * SPEED
	
	move_and_slide()
	
func _on_area_2d_body_entered(body):
	health -= 1
	health_bar.value = health * 33
	if health == 0:
		get_tree().quit()
	
