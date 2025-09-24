extends CanvasLayer

onready var control = $Control
onready var map = $Control/Map
onready var goalLabel = $Control/Goal/GoalLabel
onready var roomLabel = $Control/Room/RoomLabel

var paused = false
var opened = false

var room = "Hub"

var player

func setPlayer(p):
	player = p

func setMap(p):
	var tex = load(p)
	map.texture = tex

func setRoom(r):
	roomLabel.text = r

func setGoal(g):
	goalLabel.text = g

func _ready():
	add_to_group("menus")
	control.visible = false
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(_delta):
	if Input.is_action_just_pressed("open_map"):
		if get_tree().paused and opened:
			unpause()
		elif not get_tree().paused and not opened:
			pause()
	if Input.is_action_just_pressed("actualQuit"):
		if get_tree().paused and opened:
			unpause()

func unpause():
	opened = false
	control.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.setCanvasVisible(true)

func pause():
	player.setCanvasVisible(false)
	opened = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	control.visible = true
	get_tree().paused = true
