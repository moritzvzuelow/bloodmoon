extends StaticBody

onready var sprite = $Sprite3D
onready var light = $OmniLight

export(int) var torchNum setget setTorchNum

func setTorchNum(n):
	torchNum = n

func _get_color():
	var color_map = {
		0: Color.goldenrod,
		1: Color.lightskyblue,
		2: Color.gainsboro
	}
	return color_map.get(torchNum)


func _ready():
	if not torchNum in [0, 1, 2]:
		torchNum = 2
	add_to_group("obstacles")
	sprite.frame = torchNum
	light.light_color = _get_color()
