extends KinematicBody

const SPEED = 3
const BLOCK_SPEED = 1
const TARGET_ATTACK_RANGE = 2
const MAX_ATTACK_RANGE = 3
const BLOCK_RANGE = 5
const VIEW_DISTANCE = 25
const CORNER_CUT_DIST = 1
const BASE_MAX_HEALTH = 200
const KICK_STRENGTH = 10
const KICK_DECCEL = 10
const BASE_DAMAGE = 120

onready var global = get_node("/root/Global")
onready var nav = get_parent()
onready var player
onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape
onready var hurtboxShape = $Hurtbox/CollisionShape
onready var raycast = $RayCast
onready var light = $OmniLight

enum {
	IDLE,
	ADVANCE,
	ATTACK,
	DEAD,
	KICKED
}

# AI:
# Advances to attack range
# Attacks
# Blocks in between attacks
# Ripostes if he blocks the player
# gets staggered if kicked

var path = []
var currentPathNode = 0
var state
var kickDirection = Vector3()
var kickSpeed = 0
var blocking = false
var level
var e_damage = BASE_DAMAGE

func _ready():
	add_to_group("enemies")
	add_to_group("blockers")
	state = IDLE
	collisionShape.disabled = false
	animationPlayer.play("idlemove")
	level = get_parent().get_parent()
	global.setBossHealthMax(BASE_MAX_HEALTH)
	global.setBossHealth(BASE_MAX_HEALTH)
	global.inBossFight = true
	e_damage = BASE_DAMAGE * (1 + BloodmoonStats.enemyDamageLevel)

func setPlayer(p):
	player = p
	
# Interface Stuffs

func kick(direction):
	kickDirection = direction
	kickSpeed = KICK_STRENGTH
	blocking = false
	animationPlayer.play("kicked")
	state = KICKED

func slash(d):
	if blocking:
		riposte()
		# TODO return somtehing to make the player staggered for a second
	else:
		damage(d)

func stab(d):
	if blocking:
		riposte()
	else:
		damage(d)

func riposte():
	animationPlayer.play("startRiposte")
	pass
	
func damage(d):
	global.damageBoss(d)
	player.updateHud()
	if global.bossHealth <= 0:
		die()
	else:
		animationPlayer.play("hurt")

# runloop

func _physics_process(delta):
	if !player:
		return
	
	look_at(player.translation, Vector3(0,1,0))

	var distanceToPlayer = getDistanceToPlayer()

	if state == IDLE:
		if distanceToPlayer < VIEW_DISTANCE:
			advance()
	elif state == ATTACK:
		if animationPlayer.is_playing():
			pass
		else:
			if distanceToPlayer > MAX_ATTACK_RANGE:
				advance()
			else:
				if blocking:
					animationPlayer.play("startAttack")
				else:
					animationPlayer.play("startBlock")
	elif state == KICKED:
		kickSpeed = lerp(kickSpeed, 0, KICK_DECCEL * delta)
		if kickSpeed == 0:
			idle()
		else:
			move_and_slide(kickDirection * kickSpeed)
	elif state == ADVANCE:
		if distanceToPlayer < TARGET_ATTACK_RANGE:
			attack()
		else:
			if distanceToPlayer < BLOCK_RANGE:
				if animationPlayer.current_animation == "idlemove":
					animationPlayer.play("startBlock")
				elif !animationPlayer.is_playing():
					# keep playing holdblock
					animationPlayer.play("holdblock")
			elif blocking:
				animationPlayer.play("endBlock")
			if currentPathNode >= path.size():
				getPathToPlayer()
			var moveDirection = path[currentPathNode] - global_transform.origin
			if moveDirection.length() < CORNER_CUT_DIST:
				currentPathNode += 1
			else:
				var speed = BLOCK_SPEED if blocking else SPEED
				move_and_slide(moveDirection.normalized() * speed)
	elif state == DEAD:
		pass
	else:
		state = ADVANCE

func getVectorToPlayer():
	return player.translation - translation

func getDistanceToPlayer():
	return getVectorToPlayer().length()

func setBlock(b: bool):
	blocking = b

func tryToHitPlayer(): 
	var target = raycast.get_collider()
	if target and target.has_method("damage"):
		target.damage(e_damage)

# State Stuff

func advance():
	state = ADVANCE
	animationPlayer.play("idlemove")
	getPathToPlayer()

func attack():
	animationPlayer.play("startAttack")
	state = ATTACK

func idle():
	animationPlayer.play("idlemove")
	state = IDLE

func die():
	animationPlayer.play("die")
	hurtboxShape.queue_free()
	collisionShape.queue_free()
	light.queue_free()
	state = DEAD
	player.receiveMoons(40)
	if level.has_method("reportDeath"):
		level.reportDeath(self)
	global.inBossFight = false

func getPathToPlayer():
	path = nav.get_simple_path(global_transform.origin, player.translation)
	currentPathNode = 0
