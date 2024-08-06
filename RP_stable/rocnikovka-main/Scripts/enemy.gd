extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D


var SPEED = 3
var chase = false
var player = null
var health = 1

func _physics_process(delta):
	if chase:
		position += (player.position - position).normalized() * SPEED
	
func _process(delta):
	animated_sprite.play("default")
	if player != null and (player.position - position).normalized().x > 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	
	if(health == 0):
		queue_free()

func _on_area_2d_body_entered(body):
	player = body
	chase = true

func _on_area_2d_body_exited(body):
	player = null
	chase = false

func _on_hb_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	health -= 1
