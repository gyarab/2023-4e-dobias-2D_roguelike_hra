extends Node2D

func _on_pickup_area_body_entered(body): #removes the pickup when picked up
	queue_free()
