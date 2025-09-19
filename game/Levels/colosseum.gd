extends Spatial

const MAP_PATH = "res://assets/minimap_screenshots/colloseum_mm_cropped.png"

onready var global = get_node("/root/Global")

onready var roof = $roof
onready var devlight = $devlight
onready var gamelight = $gamelight
onready var playerGate = $playergate
onready var bossGate = $bossgate
onready var crestGate = $crestGate
onready var player = $Player

var bossReleased = false
var bossGateClosed = false

func _ready():
	player.setGoal("Find the right shield crest")
	roof.visible = true
	devlight.visible = false
	gamelight.visible = true
	bossReleased = false
	bossGateClosed = false
	player.setMap(MAP_PATH)

func _on_DoorTriggerArea_area_entered(area):
	if area.get_parent() != player:
		return
	playerGate.open()

func _on_enemyTriggerArea_area_entered(area):
	if bossReleased or area.get_parent() != player:
		return
	bossReleased = true
	bossGate.open()
	playerGate.close()

func _on_enemyTriggerArea2_area_entered(area):
	if bossGateClosed or area.get_parent() != player:
		return
	bossGateClosed = true
	bossGate.close()

func reportDeath(_creature):
	crestGate.open()

func _on_EntranceRoom_area_entered(_area:Area):
	player.setRoom("Entrance")

func _on_ArenaRoom_area_entered(_area:Area):
	player.setRoom("Arena")

func _on_RightShieldRoom_area_entered(_area:Area):
	player.setRoom("Room of the right shield")
