extends KinematicBody

onready var bloodmoonStats = get_node("/root/BloodmoonStats")

const BASE_DAMAGE = 70

var velocity = Vector3()
var target
var source
var e_damage = BASE_DAMAGE

func setSource(s):
	source = s

func setVelocity(v):
	velocity = v

func _ready():
	add_to_group("projectiles")
	e_damage = BASE_DAMAGE * (1 + bloodmoonStats.enemyDamageLevel)

func setPlayer(t):
	target = t 

func _physics_process(delta):
	if !target:
		return

	var col = move_and_collide(velocity * delta)
	if col:
		doHit(col.collider)

func doHit(collider):
	if collider == source or collider.is_in_group("enemies") or collider.is_in_group("obstacles"):
		return
	if collider.has_method("damage"):
		collider.damage(e_damage)
	queue_free() #delete self

