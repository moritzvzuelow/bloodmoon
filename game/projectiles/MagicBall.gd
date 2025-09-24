extends KinematicBody

var velocity = Vector3()
var source
var magicDamage

func setSource(s):
	source = s

func setVelocity(v):
	velocity = v

func setMagicDamage(d):
	magicDamage = d

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
	if collider.has_method("magic"):
		collider.magic(magicDamage)
	elif collider.has_method("damage"):
		collider.damage(magicDamage)
	queue_free() #delete self
