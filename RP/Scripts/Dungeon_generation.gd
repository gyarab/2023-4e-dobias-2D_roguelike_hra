extends Node2D

var boss_room = "res://Scenes/Rooms/Boss_rooms/boss_room.tscn"
var standard_rooms = {}
var start_room = "res://Scenes/Rooms/Start_rooms/start_room.tscn"
var enemies = {}

@onready var Enemy = preload("res://Scenes/Enemies/enemy_1.tscn")

var dungeon = []
var cors = Vector2i(0,0)
var instance = ""
var scene_name = ""
var grid_size = 0
var num_enemies = 0

@export var num_rooms = 10
@export var closed_if_enemy = true #to test doors showing when enemy killing does not work

@onready var TUp = get_node("TUp")
@onready var TDown = get_node("TDown")
@onready var TLeft = get_node("TLeft")
@onready var TRight = get_node("TRight")

@onready var player = get_node("Player")

func _ready():
	dungeon = []
	load_rooms()
	generate_dungeon()
	check_for_boss()
	generate_rooms()
	place_start()
	
func _physics_process(delta): #checks if doors should be open every frame
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
			
#function to load different enemies into array for easier access during spawning
func load_enemies():
	var file_num = 1
	var dir = DirAccess.open("res://Scenes/Enemies/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				enemies[file_num] = {"path": "res://Scenes/Enemies/" + file_name}
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
			dungeon[y].append("0")
	
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
	var found = 0
	for x in range(grid_size):
		for y in range(grid_size):
			if int(dungeon[x][y]) == 2:
				found += 1
	if found != 1:
		dungeon = []
		_ready()
		
#function to check if room can be placed in grid
func can_be_placed(dungeon, x, y, size):
	if	x<0 or x>size-1 or y<0 or y>size-1: #is the choosen place in the grid?ssssssss
		return false
	if str(dungeon[x][y]) != "0": #is the choosen place empty?
		return false
	return true
	
#function to generate room information
func generate_rooms():
	var rooms = {}
	dungeon[dungeon.size()/2][dungeon.size()/2] = str(start_room) #place start room in the middle
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
	
#function to load and swap room scene and spawn enemies on  a first visit of a room
func load_scene():
	remove_child(instance)
	var cleared = false
	
	if str(dungeon[cors.x][cors.y]).ends_with("C"):
		dungeon[cors.x][cors.y] = str(dungeon[cors.x][cors.y]).erase((str(dungeon[cors.x][cors.y])).length()-1, 1)
		cleared = true
		
	if str(dungeon[cors.x][cors.y]).ends_with("0") or str(dungeon[cors.x][cors.y]).ends_with("1"):
		scene_name = (str(dungeon[cors.x][cors.y])).erase((str(dungeon[cors.x][cors.y])).length()-2, 2)
	else:
		scene_name = str(dungeon[cors.x][cors.y])
		
	var scene = load(scene_name)
	instance = scene.instantiate()
	if !cleared:
		var x = instance.get_node("enemy_spawn_points").get_child_count()
		for i in range(x):
			var Enemy_instance = Enemy.instantiate()
			Enemy_instance.global_position = instance.get_node("enemy_spawn_points").get_child(i).position
			instance.add_child(Enemy_instance)
	
	add_child(instance)
	cleared = false
	
#Functions to detect direction in which the player wants to move in. ->
#Adds "C" as "cleared" on the end of dungeon cell name for handling of enemy spawning
func _on_up_body_entered(body): #if player wants to move up
	if closed_if_enemy:
		if (cors.x-1 >= 0) and (str(dungeon[cors.x-1][cors.y]) != "0") and num_enemies == 0:
			dungeon[cors.x][cors.y] = dungeon[cors.x][cors.y] + "C" 
			cors.x -= 1
			load_scene()
			player.position = Vector2i(0, 120)
	else:
		if (cors.x-1 >= 0) and (str(dungeon[cors.x-1][cors.y]) != "0"):
			dungeon[cors.x][cors.y] = dungeon[cors.x][cors.y] + "C" 
			cors.x -= 1
			load_scene()
			player.position = Vector2i(0, 120)

func _on_down_body_entered(body): #if player wants to move down
	if closed_if_enemy:
		if (cors.x+1 < grid_size) and (str(dungeon[cors.x+1][cors.y]) != "0") and num_enemies == 0:
			dungeon[cors.x][cors.y] = dungeon[cors.x][cors.y] + "C" 
			cors.x += 1
			load_scene()
			player.position = Vector2i(0, -120)
	else:
		if (cors.x+1 < grid_size) and (str(dungeon[cors.x+1][cors.y]) != "0"):
			dungeon[cors.x][cors.y] = dungeon[cors.x][cors.y] + "C" 
			cors.x += 1
			load_scene()
			player.position = Vector2i(0, -120)
			
func _on_left_body_entered(body): #if player wants to move left
	if closed_if_enemy:
		if (cors.y-1 >= 0) and (str(dungeon[cors.x][cors.y-1]) != "0") and num_enemies == 0:
			dungeon[cors.x][cors.y] = dungeon[cors.x][cors.y] + "C" 
			cors.y -= 1
			load_scene()
			player.position = Vector2i(260, 0)
	else:
		if (cors.y-1 >= 0) and (str(dungeon[cors.x][cors.y-1]) != "0"):
			dungeon[cors.x][cors.y] = dungeon[cors.x][cors.y] + "C" 
			cors.y -= 1
			load_scene()
			player.position = Vector2i(260, 0)

func _on_right_body_entered(body): #if player wants to move right
	if closed_if_enemy:
		if (cors.y+1 < grid_size) and (str(dungeon[cors.x][cors.y+1]) != "0") and num_enemies == 0:	
			dungeon[cors.x][cors.y] = dungeon[cors.x][cors.y] + "C" 
			cors.y += 1
			load_scene()
			player.position = Vector2i(-260, 0)
	else:
		if (cors.y+1 < grid_size) and (str(dungeon[cors.x][cors.y+1]) != "0"):
			dungeon[cors.x][cors.y] = dungeon[cors.x][cors.y] + "C" 
			cors.y += 1
			load_scene()
			player.position = Vector2i(-260, 0)
		
#function to display entrances/exits acordingly to room structure and enemies
#shows entrance/exit if room exists in the direction and the number of enemies is 0
func display_doors():
	if num_enemies == 0 or !closed_if_enemy:
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
	else:
		TRight.show()
		TLeft.show()
		TUp.show()
		TDown.show()
		
#function to get number of enemies in current room
func _on_enemy_detector_body_entered(body):
	num_enemies += 1

#function to keep track of how mny enemies are still alive
func _on_enemy_detector_body_exited(body):
	num_enemies -= 1
	var pickup = randi_range(1,10)
	match pickup:
		1:
			var heart = load("res://Scenes/Pickups/heart_pickup.tscn")
			heart = heart.instantiate()
			heart.position = body.position
			add_child(heart)
		2:
			var scroll = load("res://Scenes/Pickups/weapon_pickup.tscn")
			scroll = scroll.instantiate()
			scroll.position = body.position
			add_child(scroll)
