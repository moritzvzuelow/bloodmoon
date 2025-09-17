extends CanvasLayer

onready var bloodmoonStats = get_node("/root/BloodmoonStats")

onready var control = $Control
onready var bloodmoonLevelLabel = $Control/LevelPoints/LevelPointsLabel
onready var enemyHealthSlider = $Control/Level/EnemyHealth/HealthSlider
onready var enemyDamageSlider = $Control/Level/EnemyDamage/DamageSlider
onready var enemyHealingSlider = $Control/Level/EnemyHealing/HealingSlider
onready var potionDebuffSlider = $Control/Level/PotionDebuff/PDebuffSlider
onready var levelLimitSlider = $Control/Level/LevelLimit/LevelLimitSlider
onready var playerBlockingSlider = $Control/Level/PlayerBlocking/PlayerBlockingSlider

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
	control.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func updateLevelpointsLabel():
	bloodmoonLevelLabel.text = "Bloodmoon Level: %s" % bloodmoonStats.getBloodmoonLevel()

func updateBars():
	enemyHealthSlider.value = bloodmoonStats.enemyHealthLevel
	enemyDamageSlider.value = bloodmoonStats.enemyDamageLevel
	enemyHealingSlider.value = bloodmoonStats.enemyHealingLevel
	potionDebuffSlider.value = bloodmoonStats.potionDebuffLevel
	levelLimitSlider.value = bloodmoonStats.levelLimitLevel
	playerBlockingSlider.value = bloodmoonStats.blockDurationLimitLevel

func _on_HealthSlider_value_changed(value:float):
	bloodmoonStats.enemyHealthLevel = value
	updateLevelpointsLabel()

func _on_PlayerBlockingSlider_value_changed(value:float):
	bloodmoonStats.blockDurationLimitLevel = value
	updateLevelpointsLabel()

func _on_LevelLimitSlider_value_changed(value:float):
	bloodmoonStats.levelLimitLevel = value
	updateLevelpointsLabel()

func _on_PDebuffSlider_value_changed(value:float):
	bloodmoonStats.potionDebuffLevel = value
	updateLevelpointsLabel()

func _on_HealingSlider_value_changed(value:float):
	bloodmoonStats.enemyHealingLevel = value
	updateLevelpointsLabel()

func _on_DamageSlider_value_changed(value:float):
	bloodmoonStats.enemyDamageLevel = value
	updateLevelpointsLabel()
