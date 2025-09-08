extends Spatial

onready var global = get_node("/root/Global")

const POTION_MP = 50

var player

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite3D
onready var particles = $Particles

func _ready():
	add_to_group("collectibles")
	animationPlayer.play("rotate")
	particles.visible = global.particlesEnabled

func setPlayer(p):
	player = p

func _on_PickupArea_area_entered(area):
	var thing = area.get_parent()
	if thing != player:
		return
	if player.mana >= player.manaMax:
		return
	player.addMana(POTION_MP)
	player.playManaPickupAnim()
	player.updateHud()
	queue_free()

