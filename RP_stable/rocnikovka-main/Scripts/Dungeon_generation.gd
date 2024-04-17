extends Node2D

var room_data = {
	"standard": {"path": "std"},
	"boss":{"path": "boss"}
}

var boss_room = "boss"
var standard_rooms = {
	1: {"path": "res://Rooms/room.tscn"}
}
var start_room = "res://Scenes/start_room.tscn"

var dungeon = []
var cors = Vector2i(0,0)


func _ready():
	generate_dungeon(4)
	generate_rooms()
	place_start()
	
#function to generate grid representation of room layout
func generate_dungeon(num_rooms):
	var grid_size = ceil(num_rooms*0.66)
	
	#generate empty dungeon grid
	for y in range(grid_size):
		dungeon.append([])
		for x in range(grid_size):
			dungeon[y].append(0)
	#print(dungeon)
	
	#add start room in the middle
	dungeon[grid_size/2][grid_size/2] = 1
	
	cors = Vector2i(grid_size/2, grid_size/2)
	
	var rooms = 0
	
	#fill the empty grid with room structure
	while rooms < num_rooms:
		var direction = randi_range(0, 3) #0=UP, 1=DOWN, 2=LEFT, 3=RIGHT
		match direction:
			0:
				if can_be_placed(dungeon, cors.x, cors.y-1, grid_size):
					dungeon[cors.x][cors.y-1] = 1
					cors.y -= 1
					rooms += 1
					#print("good Up")
			1:
				if can_be_placed(dungeon, cors.x, cors.y+1, grid_size):
					dungeon[cors.x][cors.y+1] = 1
					cors.y += 1
					rooms += 1
					#print("good Down")
			2:
				if can_be_placed(dungeon, cors.x-1, cors.y, grid_size):
					dungeon[cors.x-1][cors.y] = 1
					cors.x -= 1
					rooms += 1
					#print("good Left")
			3:
				if can_be_placed(dungeon, cors.x+1, cors.y, grid_size):
					dungeon[cors.x+1][cors.y] = 1
					cors.x += 1
					rooms += 1
					#print("good Right")
	#for i in range(grid_size):
	#	print(dungeon[i])
	#....return dungeon
	cors = Vector2i(grid_size/2, grid_size/2)

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
	#for i in range(dungeon.size()):
		#print(dungeon[i])

#function to place start room
func place_start():
	var scene = load(standard_rooms[1]["path"])
	var instance = scene.instantiate()
	add_child(instance)
	#print_tree_pretty()
	#remove_child(instance)
	#print_tree_pretty()
#function to swap beween rooms

#function to load scenes before swap
func load_scene():
	var scene_name = (dungeon[cors.x][cors.y]).erase((dungeon[cors.x][cors.y]).length(), 2)
	print(scene_name)

func _on_up_body_entered(body): #if player wants to move up
	print("Up")
	cors.x -= 1
	load_scene()

func _on_down_body_entered(body): #if player wants to move down
	print("down")
	cors.x += 1

func _on_left_body_entered(body): #if player wants to move left
	print("left")
	cors.y -= 1

func _on_right_body_entered(body): #if player wants to move right
	print("right")
	cors.y += 1
