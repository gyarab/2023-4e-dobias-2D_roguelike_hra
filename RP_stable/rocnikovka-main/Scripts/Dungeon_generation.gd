extends Node2D

var boss_room = "res://Scenes/Rooms/Boss_rooms/boss_room.tscn"
var standard_rooms = {}
var start_room = "res://Scenes/Rooms/Start_rooms/start_room.tscn"

var dungeon = []
var cors = Vector2i(0,0)
var instance = ""
var scene_name = ""
var grid_size = 0
var num_enemies = 0
var num_rooms = 10

@onready var TUp = get_node("TUp")
@onready var TDown = get_node("TDown")
@onready var TLeft = get_node("TLeft")
@onready var TRight = get_node("TRight")

@onready var player = get_node("Player")

func _ready():
	load_rooms()
	generate_dungeon()
	check_for_boss()
	generate_rooms()
	place_start()
	
func _physics_process(delta):
	display_doors()
	
	
#easier wait function
func wait(sec):
	await get_tree().create_timer(sec).timeout
	
#function to load room scenes into array
func load_rooms():
	var file_num = 1
	var dir = DirAccess.open("res://Scenes/Rooms/Standard_rooms/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				standard_rooms[file_num] = {"path": "res://Scenes/Rooms/Standard_rooms/" + file_name}
				file_num += 1
			file_name = dir.get_next()
	
#function to generate grid representation of room layout
#with higher numbers of rooms (>40) returns "Stack overflow (stack size: 1024). Check for infinite recursion in your script." a lot
func generate_dungeon():
	grid_size = ceil(num_rooms*0.5)
	
	#generate empty dungeon grid
	for y in range(grid_size):
		dungeon.append([])
		for x in range(grid_size):
			dungeon[y].append(0)
	
	#add start room in the middle
	dungeon[grid_size/2][grid_size/2] = 1
	
	cors = Vector2i(grid_size/2, grid_size/2)
	
	var rooms = 0
	
	#fill the empty grid with room structure
	while rooms < num_rooms:
		if !can_be_placed(dungeon, cors.x, cors.y-1, grid_size) and !can_be_placed(dungeon, cors.x, cors.y+1, grid_size) and !can_be_placed(dungeon, cors.x-1, cors.y, grid_size) and !can_be_placed(dungeon, cors.x+1, cors.y, grid_size):
			dungeon = []
			generate_dungeon()
			return
		var direction = randi_range(0, 3) #0=UP, 1=DOWN, 2=LEFT, 3=RIGHT
		match direction:
			0:
				if can_be_placed(dungeon, cors.x, cors.y-1, grid_size):
					dungeon[cors.x][cors.y-1] = 1
					cors.y -= 1
					rooms += 1
			1:
				if can_be_placed(dungeon, cors.x, cors.y+1, grid_size):
					dungeon[cors.x][cors.y+1] = 1
					cors.y += 1
					rooms += 1
			2:
				if can_be_placed(dungeon, cors.x-1, cors.y, grid_size):
					dungeon[cors.x-1][cors.y] = 1
					cors.x -= 1
					rooms += 1
			3:
				if can_be_placed(dungeon, cors.x+1, cors.y, grid_size):
					dungeon[cors.x+1][cors.y] = 1
					cors.x += 1
					rooms += 1
					
	if !can_be_placed(dungeon, cors.x, cors.y-1, grid_size) and !can_be_placed(dungeon, cors.x, cors.y+1, grid_size) and !can_be_placed(dungeon, cors.x-1, cors.y, grid_size) and !can_be_placed(dungeon, cors.x+1, cors.y, grid_size):
		dungeon = []
		generate_dungeon()
		return
	else:
		var direction = randi_range(0, 3) #0=UP, 1=DOWN, 2=LEFT, 3=RIGHT
		match direction:
			0:
				if can_be_placed(dungeon, cors.x, cors.y-1, grid_size):
					dungeon[cors.x][cors.y-1] = 2
			1:
				if can_be_placed(dungeon, cors.x, cors.y+1, grid_size):
					dungeon[cors.x][cors.y+1] = 2
			2:
				if can_be_placed(dungeon, cors.x-1, cors.y, grid_size):
					dungeon[cors.x-1][cors.y] = 2
			3:
				if can_be_placed(dungeon, cors.x+1, cors.y, grid_size):
					dungeon[cors.x+1][cors.y] = 2
	cors = Vector2i(grid_size/2, grid_size/2)

#function to check if boss room was created
func check_for_boss():
	var found = false
	for x in range(grid_size):
		for y in range(grid_size):
			if int(dungeon[x][y]) == 2:
				found = true
	if found == false:
		generate_dungeon()
	for i in range(grid_size):
		print(dungeon[i])
#function to check if room can be placed in grid
func can_be_placed(dungeon, x, y, size):
	if	x<0 or x>size-1 or y<0 or y>size-1: #is the choosen place in the grid?
		return false
	if dungeon[x][y] != 0: #is the choosen place empty?
		return false
	return true
	
#function to generate room information
func generate_rooms():
	var rooms = {}
	dungeon[dungeon.size()/2][dungeon.size()/2] = start_room #place start room in the middle
	for y in range(dungeon.size()):
		for x in range(dungeon.size()):
			if int(dungeon[x][y]) == 1:
				dungeon[x][y] = standard_rooms[randi_range(1,standard_rooms.size())]["path"] + " 0" #asign a random room scene and set is as not cleared
			elif int(dungeon[x][y]) == 2:
				dungeon[x][y] = boss_room + " 0"

#function to place start room
func place_start():
	var scene = load(dungeon[grid_size/2][grid_size/2])
	instance = scene.instantiate()
	add_child(instance)
	player.position = Vector2i(0, 0)
	
#function to load and swap room scene
func load_scene():
	remove_child(instance)
	if str(dungeon[cors.x][cors.y]).ends_with("0") or str(dungeon[cors.x][cors.y]).ends_with("1"):
		scene_name = (str(dungeon[cors.x][cors.y])).erase((str(dungeon[cors.x][cors.y])).length()-2, 2)
	else:
		scene_name = str(dungeon[cors.x][cors.y])
	var scene = load(scene_name)
	instance = scene.instantiate()
	add_child(instance)
	
func _on_up_body_entered(body): #if player wants to move up
	#print("Up")
	if (cors.x-1 >= 0) and (str(dungeon[cors.x-1][cors.y]) != "0"):
		cors.x -= 1
		load_scene()
		player.position = Vector2i(0, 120)

func _on_down_body_entered(body): #if player wants to move down
	if (cors.x+1 < grid_size) and (str(dungeon[cors.x+1][cors.y]) != "0"):
		cors.x += 1
		load_scene()
		player.position = Vector2i(0, -120)
		
func _on_left_body_entered(body): #if player wants to move left
	if (cors.y-1 >= 0) and (str(dungeon[cors.x][cors.y-1]) != "0"):
		cors.y -= 1
		load_scene()
		player.position = Vector2i(260, 0)

func _on_right_body_entered(body): #if player wants to move right
	if (cors.y+1 < grid_size) and (str(dungeon[cors.x][cors.y+1]) != "0"):	
		cors.y += 1
		load_scene()
		player.position = Vector2i(-260, 0)
		
#function to display entrances/exits acordingly to room structure and enemies
#shows entrance/exit if room exists in the direction and the number of enemies is 0
func display_doors():
	if num_enemies == 0:
		if cors.x-1 >= 0 and str(dungeon[cors.x-1][cors.y]) != "0":
			TUp.hide()
		else:
			TUp.show()
		
		if cors.x+1 < grid_size and str(dungeon[cors.x+1][cors.y]) != "0":
			TDown.hide()
		else:
			TDown.show()
		
		if cors.y-1 >= 0 and str(dungeon[cors.x][cors.y-1]) != "0":
			TLeft.hide()
		else:
			TLeft.show()
		
		if cors.y+1 < grid_size and str(dungeon[cors.x][cors.y+1]) != "0":
			TRight.hide()
		else:
			TRight.show()	

#function to get number of enemies in current room

#func get_enemy_count():
	#num_enemies = 
