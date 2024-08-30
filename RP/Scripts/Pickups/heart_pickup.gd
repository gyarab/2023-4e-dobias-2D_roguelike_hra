extends Node2D


func _on_pickup_area_body_entered(body):
	queue_free()


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
