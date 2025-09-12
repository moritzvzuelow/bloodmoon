extends CanvasLayer

onready var playerStats = get_node("/root/PlayerStats")

onready var control = $Control
onready var levelPointsLabel = $Control/LevelPoints/LevelPointsLabel
onready var healthSlider = $Control/Level/Health/HealthSlider
onready var staminaSlider = $Control/Level/Stamina/StaminaSlider
onready var manaSlider = $Control/Level/Mana/ManaSlider
onready var strengthSlider = $Control/Level/Strength/StrengthSlider
onready var magicSlider = $Control/Level/Magic/MagicSlider
onready var moonsLabel = $Control/Moons/Label
onready var button = $Control/Levelup/Button

var paused = false
var opened = false


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
	updateLevelpointsLabel()
	updateBars()
	updateMoonsLabel()
	updateButton()
	control.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func getUpdatedLevel(old_level, new_level):
	var actual_level = 0
	if new_level > old_level:
		var diff = new_level - old_level
		diff = clamp(diff, 0, playerStats.remainingLevelPoints)
		actual_level = old_level + diff
		playerStats.remainingLevelPoints -= diff
	else:
		var diff = old_level - new_level
		playerStats.remainingLevelPoints += diff
		actual_level = new_level
	return actual_level

func updateLevelpointsLabel():
	levelPointsLabel.text = "Levelpoints: %s" % playerStats.remainingLevelPoints

func updateBars():
	healthSlider.value = playerStats.healthLevel
	staminaSlider.value = playerStats.staminaLevel
	manaSlider.value = playerStats.manaLevel
	strengthSlider.value = playerStats.strengthLevel
	magicSlider.value = playerStats.magicLevel

func updateMoonsLabel():
	moonsLabel.text = str(playerStats.moons)

func updateButton():
	button.text = "Level Up (%s)" % playerStats.levelup_cost
	if playerStats.levelUpPossible():
		button.disabled = false
	else:
		button.disabled = true

func _on_MagicSlider_value_changed(value:float):
	var actualLevel = getUpdatedLevel(playerStats.magicLevel, value)
	playerStats.magicLevel = actualLevel
	magicSlider.value = actualLevel
	playerStats.updateMagicDamage()
	updateLevelpointsLabel()

func _on_HealthSlider_value_changed(value:float):
	var actualLevel = getUpdatedLevel(playerStats.healthLevel, value)
	playerStats.healthLevel = actualLevel
	healthSlider.value = actualLevel
	playerStats.updateHealthMax()
	updateLevelpointsLabel()

func _on_StaminaSlider_value_changed(value:float):
	var actualLevel = getUpdatedLevel(playerStats.staminaLevel, value)
	playerStats.staminaLevel = actualLevel
	staminaSlider.value = actualLevel
	playerStats.updateStaminaMax()
	updateLevelpointsLabel()

func _on_ManaSlider_value_changed(value:float):
	var actualLevel = getUpdatedLevel(playerStats.manaLevel, value)
	playerStats.manaLevel = actualLevel
	manaSlider.value = actualLevel
	playerStats.updateManaMax()
	updateLevelpointsLabel()

func _on_StrengthSlider_value_changed(value:float):
	var actualLevel = getUpdatedLevel(playerStats.strengthLevel, value)
	playerStats.strengthLevel = actualLevel
	strengthSlider.value = actualLevel
	playerStats.updatePhysicalDamage()
	updateLevelpointsLabel()

func _on_Button_pressed():
	playerStats.levelup()
	updateLevelpointsLabel()
	updateMoonsLabel()
	updateButton()
