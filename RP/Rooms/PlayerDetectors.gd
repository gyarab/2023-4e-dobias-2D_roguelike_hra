extends Area2D

func _process(delta):
	for x in range(get_child_count()):
		print(x)
