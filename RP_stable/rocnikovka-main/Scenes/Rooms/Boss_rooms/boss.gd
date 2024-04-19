extends AnimatedSprite2D

var direction_x = 0 #0=Right, 1=Left
var direction_y = 0 #0=Down, 1=Up

var speed = 100
var direction = Vector2(0, 0)

func _process(delta):
	play("default")
	set_direction()
	movement()
	print(position)

#function to set thew direction vector
func set_direction():
	if direction_x == 0:
		direction.x = 1
	else:
		direction.x = 0
	
	if direction_y == 0:
		direction.y = 1
	else:
		direction.y = 0
		
#function to handle movement
func movement():
	position = position + (direction.normalized() * speed)
