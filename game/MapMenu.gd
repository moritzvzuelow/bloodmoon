extends CanvasLayer

onready var control = $Control
onready var map = $Control/Map
onready var goalLabel = $Control/Goal/GoalLabel

var paused = false
var opened = false

func setMap(p):
	var tex = load(p)
	map.texture = tex

func setGoal(g):
	goalLabel.text = g

func _ready():
	control.visible = false
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(_delta):
	if Input.is_action_just_pressed("open_map"):
		if get_tree().paused and opened:
			unpause()
		elif not get_tree().paused and not opened:
			pause()

func unpause():
	opened = false
	control.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	opened = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	control.visible = true
	get_tree().paused = true
