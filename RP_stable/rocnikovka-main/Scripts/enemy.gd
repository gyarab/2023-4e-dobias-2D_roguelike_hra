extends CharacterBody2D

var SPEED = 3
var chase = false
var player = null

func _physics_process(delta):
	if chase:
		position += (player.position - position).normalized() * SPEED
		
func _on_area_2d_body_entered(body):
	player = body
	chase = true

func _on_area_2d_body_exited(body):
	player = null
	chase = false
