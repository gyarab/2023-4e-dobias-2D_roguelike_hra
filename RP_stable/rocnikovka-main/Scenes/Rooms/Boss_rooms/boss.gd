extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

var speed = 200
var health = 15
var direction = Vector2(1, 1)
var hit_counter = 0
var stun_duration = 3.0
var stunned_timer = 0.0
var hit_detector = true

func _process(delta):
	animated_sprite.play("default")

func _physics_process(delta):
	print(direction)
	if hit_counter >= 7: # 7 == 5 ????
		stunned_timer += delta
		if stunned_timer >= stun_duration:
			hit_counter = 0
			stunned_timer = 0.0
		return
	else:
		velocity = direction.normalized() * speed
		move_and_slide()
		
func _on_up_body_entered(body):
	direction.y = randf_range(0.1, 0.9)
	if hit_detector == true:
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
	print("au")
	health -= 1
	if health == 0:
		get_tree().change_scene_to_file("res://Scenes/Start_menu.tscn")
