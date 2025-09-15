extends Spatial

onready var roof = $Walls2
onready var global = get_node("/root/Global")

var hasKey = [false, false]

func _ready():
	global.currentGoal = "Find the sword crest"
	roof.visible=true

func playerHasKey(i):
	return hasKey[i]

func acquireKey(i):
	hasKey[i] = true
	
func removeKey(i):
	hasKey[i] = false
