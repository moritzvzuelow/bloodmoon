extends Spatial

const MAP_PATH = "res://assets/minimap_screenshots/graveyard_mm_cropped.png"

onready var global = get_node("/root/Global")

onready var devlight = $DirectionalLight
onready var gamelight = $DirectionalLight2
onready var player = $Player

var hasKey = [false, false]

func _ready():
	player.setGoal("Find the left shield crest")
	devlight.visible = false
	gamelight.visible = true
	player.setMap(MAP_PATH)

func playerHasKey(i):
	return hasKey[i]

func acquireKey(i):
	hasKey[i] = true
	
func removeKey(i):
	hasKey[i] = false

func _on_EntranceRoom_area_entered(_area:Area):
	player.setRoom("Entrance")

func _on_LabRoom_area_entered(_area:Area):
	player.setRoom("The Labyrinth")

func _on_GhoulGraveyardRoom_area_entered(_area:Area):
	player.setRoom("Ghoul Graveyard")

func _on_LeftShieldRoom_area_entered(_area:Area):
	player.setRoom("Room of the left Shield")
