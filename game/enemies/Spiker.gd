extends KinematicBody

onready var global = get_node("/root/Global")
onready var bloodmoonStats = get_node("/root/BloodmoonStats")

const SPEED = 0.5
const MAX_ATTACK_RANGE = 15
const VIEW_DISTANCE = 20
const CORNER_CUT_DIST = 1
const MAX_HEALTH = 10
const KICK_STRENGTH = 10
const KICK_DECCEL = 10
const BASE_DAMAGE = 100

onready var nav = get_parent()
onready var player
onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape
onready var hurtboxShape = $HurtBox/CollisionShape
onready var particles = $Particles
onready var sprite = $Sprite3D
onready var triggerArea = $TriggerArea

enum {
	IDLE,
	ADVANCE,
	ATTACK,
	DEAD,
	KICKED,
	HURT
}

var path = []
var currentPathNode = 0
var state
var maxHealth = MAX_HEALTH
var health = maxHealth
var kickDirection = Vector3()
var kickSpeed = 0
var e_damage = BASE_DAMAGE


func _ready():
	add_to_group("enemies")
	idle()
	collisionShape.disabled = false
	particles.visible = global.particlesEnabled
	e_damage = BASE_DAMAGE * (1 + bloodmoonStats.enemyDamageLevel)
	maxHealth = MAX_HEALTH * (1 + bloodmoonStats.enemyHealthLevel)
	health = maxHealth

func setPlayer(p):
	player = p
	
# Interface Stuffs

func kick(direction):
	kickDirection = direction
	kickSpeed = KICK_STRENGTH
	animationPlayer.play("hurt")
	state = KICKED
	
func slash(d):
	damage(d)

func stab(d):
	damage(d)
	
func damage(d):
	health -= d
	if health <= 0:
		die()
	else:
		hurt()


func _process(delta):
	if !player:
		return

	look_at(player.translation, Vector3(0,1,0))

	var distanceToPlayer = getDistanceToPlayer()

	if state == IDLE:
		if distanceToPlayer < MAX_ATTACK_RANGE:
			pass
		elif distanceToPlayer < VIEW_DISTANCE:
			advance()
	elif state == ATTACK:
		if animationPlayer.is_playing():
			pass
		else:
			if distanceToPlayer > MAX_ATTACK_RANGE:
				advance()
	elif state == KICKED:
		kickSpeed = lerp(kickSpeed, 0, KICK_DECCEL * delta)
		if kickSpeed == 0:
			idle()
		else:
			move_and_slide(kickDirection * kickSpeed)
	elif state == ADVANCE:
		if distanceToPlayer < MAX_ATTACK_RANGE:
			idle()
		else:
			if currentPathNode >= path.size():
				getPathToPlayer()
			var moveDirection = path[currentPathNode] - global_transform.origin
			if moveDirection.length() < CORNER_CUT_DIST:
				currentPathNode += 1
			else:
				move_and_slide(moveDirection.normalized() * SPEED)
	elif state == DEAD or state == HURT:
		pass

func getVectorToPlayer():
	return player.translation - translation

func getDistanceToPlayer():
	return getVectorToPlayer().length()

func heal():
	health = clamp(health + bloodmoonStats.getHealingAmount(maxHealth), 0, maxHealth)

# State Stuff

func advance():
	state = ADVANCE
	animationPlayer.play("walk")
	getPathToPlayer()

func attack(target):
	animationPlayer.play("attack")
	state = ATTACK
	target.damage(e_damage)
	heal()

func idle():
	animationPlayer.play("idle")
	state = IDLE

func hurt():
	animationPlayer.play("hurt")
	state = HURT

func die():
	animationPlayer.play("die")
	triggerArea.monitoring = false
	hurtboxShape.queue_free()
	collisionShape.queue_free()
	triggerArea.queue_free()
	state = DEAD
	player.receiveMoons(20)

func getPathToPlayer():
	path = nav.get_simple_path(global_transform.origin, player.translation)
	currentPathNode = 0

func _on_TriggerArea_area_entered(area:Area):
	var target = area.get_parent()
	if target != player:
		return
	attack(target)


func _on_TriggerArea_area_exited(area:Area):
	var target = area.get_parent()
	if target != player:
		return
	idle()
