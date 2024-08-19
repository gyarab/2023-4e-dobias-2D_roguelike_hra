extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

var speed = 200
var health = 15
var direction = Vector2(1, 1)
var hit_counter = 0

func _process(delta):
	animated_sprite.play("default")

func _physics_process(delta):
	velocity = direction.normalized() * speed
	move_and_slide()
	
	if hit_counter >= 5:
		print("A") # TODO add wait function - head hurts...
		hit_counter = 0

func _on_up_body_entered(body):
	direction.y = 1
	hit_counter += 1

func _on_down_body_entered(body):
	direction.y = -1
	hit_counter += 1

func _on_left_body_entered(body):
	direction.x = 1
	hit_counter += 1

func _on_right_body_entered(body):
	direction.x = -1
	hit_counter += 1

func _on_hb_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("au")
	health -= 1
	if health == 0:
		get_tree().change_scene_to_file("res://Scenes/Start_menu.tscn")

#TODO boss bouncing off of player. Boss does not deal damage
