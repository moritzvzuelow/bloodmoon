extends Spatial


var player

func setPlayer(p):
	player = p

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("interactables")

func use():
	player.openLevelMenu()

func getTooltip():
	return "Build your skills"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
