extends CharacterBody2D

func _on_area_2d_body_entered(body):#removes the pickup when picked up
	queue_free()
