extends CanvasLayer

onready var control = $Control
onready var levelPointsLabel = $Control/LevelPoints/LevelPointsLabel
onready var healthSlider = $Control/Level/Health/HealthSlider
onready var staminaSlider = $Control/Level/Stamina/StaminaSlider
onready var manaSlider = $Control/Level/Mana/ManaSlider
onready var strengthSlider = $Control/Level/Strength/StrengthSlider
onready var magicSlider = $Control/Level/Magic/MagicSlider

var player
var paused = false
var opened = false

func setPlayer(p):
	player = p

func _ready():
	control.visible = false
	pause_mode = Node.PAUSE_MODE_PROCESS
	control.pause_mode = Node.PAUSE_MODE_PROCESS

func _physics_process(_delta):
	if Input.is_action_just_pressed("actualQuit"):
		if get_tree().paused and opened:
			closeLevelMenu()

func closeLevelMenu():
	opened = false
	control.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func openLevelMenu():
	opened = true
	get_tree().paused = true
	levelPointsLabel.text = "Levelpoints: %s" % player.remainingLevelPoints
	control.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_MagicSlider_value_changed(value:float):
	if (value - player.magicLevel) > player.remainingLevelPoints:
		player.magicLevel = player.remainingLevelPoints
		magicSlider.value = player.remainingLevelPoints
		player.remainingLevelPoints = 0
	else:
		player.magicLevel = value
		player.remainingLevelPoints -= value - player.magicLevel

func _on_StrengthSlider_value_changed(value:float):
	player.strengthLevel = value

func _on_ManaSlider_value_changed(value:float):
	player.manaLevel = value

func _on_StaminaSlider_value_changed(value:float):
	player.staminaLevel = value

func _on_HealthSlider_value_changed(value:float):
	player.healthLevel = value
