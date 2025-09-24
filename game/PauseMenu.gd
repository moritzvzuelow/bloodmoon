extends CanvasLayer

onready var global = get_node("/root/Global")

onready var audio = $AudioStreamPlayer
onready var control = $Control
onready var buttons = $Control/Sprite/Buttons
onready var controls = $Control/Sprite/Controls
onready var sensSlider = $Control/SensSprite/HSlider

var paused = false
var opened = false
var showingControls = false

var player

func setPlayer(p):
	player = p

signal senseChanged(value)

func _ready():
	add_to_group("menus")
	control.visible = false
	controls.visible = false
	audio.playing = false
	pause_mode = Node.PAUSE_MODE_PROCESS
	control.pause_mode = Node.PAUSE_MODE_PROCESS
	buttons.pause_mode = Node.PAUSE_MODE_PROCESS
	controls.pause_mode = Node.PAUSE_MODE_PROCESS
	sensSlider.pause_mode = Node.PAUSE_MODE_PROCESS
	sensSlider.value = global.sensitivity

func _physics_process(_delta):
	if get_tree().paused and Input.is_action_just_pressed("ui_accept") and not showingControls:
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
	elif Input.is_action_just_pressed("actualQuit"):
		if get_tree().paused and opened:
			unpause()
		elif not get_tree().paused and not opened:
			pause()
	elif Input.is_action_just_pressed("see_controls") and opened:
		toggleShowControls()

func unpause():
	opened = false
	audio.playing = false
	control.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.setCanvasVisible(true)

func pause():
	player.setCanvasVisible(false)
	opened = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	audio.playing = true
	control.visible = true
	get_tree().paused = true

func toggleShowControls():
	buttons.visible = !buttons.visible
	controls.visible = !controls.visible
	showingControls = !showingControls

func _on_HSlider_value_changed(value):
	global.sensitivity = int(value)
	emit_signal("senseChanged", value)
