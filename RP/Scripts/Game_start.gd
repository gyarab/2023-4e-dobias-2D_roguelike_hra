extends Button
@export var grid_size: int = 11 #grid_size X grid_size
@export var num_rooms: int = 15
var room_grid: Array = []
var grid: Array = []
var file_path = "res://Room_array/array.txt"


func _pressed():
	"""
	Rooms:
		1 - Start room
		2 - Normal room
		
	Connections:
		2 - Up
		4 - Down
		8 - Left
		16 - Right
	"""

	dungeon_generate()
	create_rooms()
	swap_scene()
	
func dungeon_generate():
	
	var room_count: int = 0
	var cor_x: int = grid_size/2
	var cor_y: int = grid_size/2
	
	var connections_grid: Array = []
	
	for x in range(grid_size):
		var col: Array = []
		for y in range(grid_size):
			col.append(0)
		grid.append(col)
		
	for x in range(grid_size):
		var col: Array = []
		for y in range(grid_size):
			col.append(0)
		connections_grid.append(col)
		
	grid[grid_size/2][grid_size/2] = 1
	
	while room_count < num_rooms:
		var dir: int = randi_range(1, 4) # 1 = Up, 2 = Down, 3 = Left, 4 = Right  
		
		if (dir == 1) and (cor_y - 1 >= 0) and grid[cor_x][cor_y - 1] == 0:
			cor_y -= 1
			grid[cor_x][cor_y] = 2
			room_count += 1
		if (dir == 2) and (cor_y + 1 <= grid_size - 1) and grid[cor_x][cor_y + 1] == 0:
			cor_y += 1
			grid[cor_x][cor_y] = 2
			room_count += 1
		if (dir == 3) and (cor_x - 1 >= 0) and grid[cor_x - 1][cor_y] == 0:
			cor_x -= 1
			grid[cor_x][cor_y] = 2
			room_count += 1
		if (dir == 4) and (cor_x + 1 <= grid_size - 1) and grid[cor_x + 1][cor_y] == 0:
			cor_x += 1
			grid[cor_x][cor_y] = 2
			room_count += 1
			
	for x in range(grid_size):
		for y in range(grid_size):
			var room_value = grid[x][y]
			if room_value != 0:  # Check if it's a room (not empty space)
		# Check for connections in all directions
				if y > 0 and grid[x][y - 1] != 0:  # Left
					connections_grid[x][y] += 8
				if y < grid_size - 1 and grid[x][y + 1] != 0:  # Right
					connections_grid[x][y] += 16
				if x > 0 and grid[x - 1][y] != 0:  # Up
					connections_grid[x][y] += 2
				if x < grid_size - 1 and grid[x + 1][y] != 0:  # Down
					connections_grid[x][y] += 4
					
	return connections_grid

func create_rooms(): # https://docs.godotengine.org/en/stable/classes/class_diraccess.html
	var room_array = []
	var posible_rooms = []
	var gen_grid = dungeon_generate()
	
	var found = false
	
	var connection_int = 0
	
	var rooms_up = []
	var rooms_down = []
	var rooms_left = []
	var rooms_right = []
	
	var room_folder = "res://Rooms"
	var dir = DirAccess.open(room_folder)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() == false:
				room_array.append("res://Rooms/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	for x in range (room_array.size()):
		var scene = load(room_array[x])
		var instance = scene.instantiate()
		for y in range(instance.get_child(1).get_child_count()):
			if str(instance.get_child(1).get_child(y)).begins_with("Up"):
				rooms_up.append(room_array[x])
			if str(instance.get_child(1).get_child(y)).begins_with("Down"):
				rooms_down.append(room_array[x])
			if str(instance.get_child(1).get_child(y)).begins_with("Left"):
				rooms_left.append(room_array[x])
			if str(instance.get_child(1).get_child(y)).begins_with("Right"):
				rooms_right.append(room_array[x])
		
	for x in range(grid_size):
		var col: Array = []
		for y in range(grid_size):
			col.append(0)
		room_grid.append(col)
	
	
	for x in range(grid_size):
		for y in range(grid_size):
			posible_rooms.clear()
			posible_rooms = posible_rooms + room_array
			connection_int = gen_grid[x][y]
			if connection_int > 0:
				
				if connection_int >= 16:
					connection_int -= 16
					for i in range(posible_rooms.size() - 1, -1, -1):
							for ii in range(rooms_right.size()):
								if posible_rooms[i] == rooms_right[ii]:
									found = true
							if found == false:
								#print("X: ", posible_rooms[i])
								posible_rooms.remove_at(i)
							found = false
				else:
					for i in range(rooms_right.size()):
						if rooms_right[i] in posible_rooms:
							posible_rooms.erase(rooms_right[i])
							
				if connection_int >= 8:
					connection_int -= 8
					for i in range(posible_rooms.size() - 1, -1, -1):
							for ii in range(rooms_left.size()):
								if posible_rooms[i] == rooms_left[ii]:
									found = true
							if found == false:
								posible_rooms.remove_at(i)
							found = false
				else:
					for i in range(rooms_left.size()):
						if rooms_left[i] in posible_rooms:
							posible_rooms.erase(rooms_left[i])
										
				if connection_int >= 4:
					connection_int -= 4
					for i in range(posible_rooms.size() - 1, -1, -1):
							for ii in range(rooms_down.size()):
								if posible_rooms[i] == rooms_down[ii]:
									found = true
							if found == false:
								posible_rooms.remove_at(i)
							found = false
				else:
					for i in range(rooms_down.size()):
						if rooms_down[i] in posible_rooms:
							posible_rooms.erase(rooms_down[i])
										
				if connection_int >= 2:
					connection_int -= 2
					for i in range(posible_rooms.size() - 1, -1, -1):
							for ii in range(rooms_up.size()):
								if posible_rooms[i] == rooms_up[ii]:
									found = true
							if found == false:
								posible_rooms.remove_at(i)
							found = false
				else:
					for i in range(rooms_up.size()):
						if rooms_up[i] in posible_rooms:
							posible_rooms.erase(rooms_up[i])
										
				if not posible_rooms.is_empty():
					var room = str(posible_rooms)
					room = room.erase(0,2)
					room = room.erase(room.length()-2, 2)
					room_grid[x][y] = room
	save_rooms()

func save_rooms():
	var save = FileAccess.open(file_path, FileAccess.WRITE)
	save.store_var(grid_size/2)
	save.store_var(grid_size/2)
	save.store_var(room_grid)
	save.close()
	


func swap_scene():
	var room = str(room_grid[grid_size/2][grid_size/2])
	get_tree().change_scene_to_file(room)
	
