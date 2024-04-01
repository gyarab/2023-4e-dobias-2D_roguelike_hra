extends Node2D

var connections: Array = []
var enemy_spawn_points: Array = []
var player_detection_areas: Array = []

var cleared: bool = false

var num_connections: int
var num_enemy_spawn_points: int
var num_player_detection_areas: int

var file_path = "res://Room_array/array.txt"

var room_x: int = 0
var room_y: int = 0
var rooms: Array = []

@onready var EnemyPositions: Node2D = get_node("EnemyPositions")
@onready var Doors: Node2D = get_node("Doors")
@onready var PlayerDetectors: Area2D = get_node("PlayerDetectors")
@onready var Tilemap2: TileMap = get_node("TileMap2")
@onready var Enemy = load("res://Characters/enemy_1.tscn")

@onready var Player: Node2D = get_node("player")

@onready var num_enemies = 0#EnemyPositions.get_child_count()

func _ready():	
	load_rooms()
	Player.position = PlayerDetectors.get_child(0).position
	
	if cleared == false:
		for enemy_spawn_point in range(EnemyPositions.get_child_count()):
			var Enemy_instance = Enemy.instantiate()
			add_child(Enemy_instance)
			
			var x: Marker2D = get_node(EnemyPositions.get_child(enemy_spawn_point).get_path())
			Enemy_instance.position = x.position
			num_enemies += 1
		
	for connection in range(Doors.get_child_count()):
		connections.append(Doors.get_child(connection)) 
		
	for player_detector in range(PlayerDetectors.get_child_count()):
		player_detection_areas.append(PlayerDetectors.get_child(player_detector))
		
	num_enemies = EnemyPositions.get_child_count()
	
	#func leaving room
	#func spawn in room
	#func on enemy death - num_enemies - 1
	#func on room enter spawn enemies
	
	if num_enemies == 0:
		cleared = true
		

func _physics_process(delta):
	var save = FileAccess.open(file_path, FileAccess.READ)
	var cur_room_x = save.get_var()
	var cur_room_y = save.get_var()
	if (room_x != cur_room_x) or (room_y != cur_room_y):
		get_tree().change_scene_to_file(rooms[int(cur_room_x)][int(cur_room_y)])
			
	if cleared:
		Tilemap2.visible = false

func load_rooms():
	var save = FileAccess.open(file_path, FileAccess.READ)
	room_x = save.get_var()
	room_y = save.get_var()
	rooms = save.get_var()
	save.close()

"""
func save_rooms():
	var save = FileAccess.open(file_path,FileAccess.WRITE)
	save.store_var(room_x)
	save.store_var(room_y)
	save.
"""
func save_rooms():
	"""
	col up > y - 1
		down > y + 1
		left > x - 1
		right > y + 1
	"""
