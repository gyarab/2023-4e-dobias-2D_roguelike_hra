extends CharacterBody2D

var SPEED = 3
var chase = false
var player = null
var health = 1

func _physics_process(delta):
	if chase:
		position += (player.position - position).normalized() * SPEED
	if health <= 0:
		print("enemy died")
	else:
		print("enemy alive")
	print(health)
		
func _on_area_2d_body_entered(body):
	player = body
	chase = true

func _on_area_2d_body_exited(body):
	player = null
	chase = false

func _on_hitbox_body_entered(body):
	health -= 1
