extends Spatial

const MAP_PATH = "res://assets/minimap_screenshots/catacombs_mm_cropped.png"

const goal = "Find the sword crest\nThe lights will lead the way"

onready var roof = $Walls2
onready var global = get_node("/root/Global")
onready var player = $Player

var hasKey = [false, false]

func _ready():
	player.setGoal(goal)
	roof.visible=true
	player.setMap(MAP_PATH)

func playerHasKey(i):
	return hasKey[i]

func acquireKey(i):
	hasKey[i] = true
	
func removeKey(i):
	hasKey[i] = false

func _on_ThousandWaysRoomArea_area_entered(_area:Area):
	player.setRoom("Room of 1000 Ways")

func _on_SwordRoomsArea_area_entered(_area:Area):
	player.setRoom("Rooms of the sword")

func _on_SkeletonGraveRoom_area_entered(_area:Area):
	player.setRoom("Skeleton Grave")

func _on_NowhereArea_area_entered(_area:Area):
	player.setRoom("Nowhere")

func _on_EntranceRoomArea_area_entered(_area:Area):
	player.setRoom("Entrance")
