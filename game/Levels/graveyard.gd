extends Spatial

onready var global = get_node("/root/Global")

onready var devlight = $DirectionalLight
onready var gamelight = $DirectionalLight2

var hasKey = [false, false]

func _ready():
	global.currentGoal = "Find the left shield crest"
	devlight.visible = false
	gamelight.visible = true

func playerHasKey(i):
	return hasKey[i]

func acquireKey(i):
	hasKey[i] = true
	
func removeKey(i):
	hasKey[i] = false
