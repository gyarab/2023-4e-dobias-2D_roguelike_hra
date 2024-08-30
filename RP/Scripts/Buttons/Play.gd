extends Button

func _pressed():
	get_tree().change_scene_to_file("res://Scenes/dungeon.tscn") #starts the game
