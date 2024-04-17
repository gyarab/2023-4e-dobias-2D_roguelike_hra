extends Node2D

var room_data = {
	"standard": {"path": "std"},
	"boss":{"path": "boss"}
}

var boss_room = "boss"
var standard_rooms = {
	1: {"path": "1"},
	2: {"path": "2"},
	3: {"path": "3"},
	4: {"path": "4"},
	5: {"path": "5"},
	6: {"path": "6"},
	7: {"path": "7"},
	8: {"path": "8"},
	9: {"path": "9"},
	10: {"path": "10"}
}
var start_room = "start"

var dungeon = []


func _ready():
	generate_dungeon(10)
	generate_rooms()
	
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
	
	var cors = Vector2i(grid_size/2, grid_size/2)
	
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
	for i in range(dungeon.size()):
		print(dungeon[i])

#function to place start room
func place_start():
	print("help")
	
#function to swap beween rooms

	
