extends KinematicBody

const DAMAGE = 10

var velocity = Vector3()
var source
var magicModifier

func setSource(s):
	source = s

func setVelocity(v):
	velocity = v

func setMagicModifier(d):
	magicModifier = d

func _ready():
	$CollisionShape.disabled = true
	yield(get_tree(), "physics_frame")
	$CollisionShape.disabled = false
	add_to_group("projectiles")


func _physics_process(delta):
	var col = move_and_collide(velocity * delta)
	if col:
		doHit(col.collider)

func doHit(collider):
	if collider == source or collider.is_in_group("obstacles"):
		return
	if collider.has_method("damage"):
		collider.damage(DAMAGE + magicModifier * DAMAGE)
	queue_free() #delete self
