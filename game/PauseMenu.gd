extends CanvasLayer


onready var audio = $AudioStreamPlayer
onready var control = $Control
onready var sensSlider = $Control/SensSprite/HSlider

var paused = false

signal senseChanged(value)

func _ready():
	control.visible = false
	audio.playing = false
	pause_mode = Node.PAUSE_MODE_PROCESS
	control.pause_mode = Node.PAUSE_MODE_PROCESS
	sensSlider.pause_mode = Node.PAUSE_MODE_PROCESS

func _physics_process(delta):
	if get_tree().paused and Input.is_action_just_pressed("ui_accept"):
		get_tree().quit()
	elif Input.is_action_just_pressed("actualQuit"):
		if get_tree().paused:
			unpause()
		else:
			pause()

func unpause():
	audio.playing = false
	control.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	audio.playing = true
	control.visible = true
	get_tree().paused = true

func _on_HSlider_value_changed(value):
	emit_signal("senseChanged", value)
