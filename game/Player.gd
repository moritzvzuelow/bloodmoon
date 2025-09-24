extends KinematicBody

const SPEED = 5
const ACCEL = 10
const BLOOD_SCALE = 5
const MAGICBALL_START_DISTANCE = 1
const MAGICBALL_SPEED = 10
const MAGICBALL_HEIGHT = 0.75
const MAX_CHARGE_TIME = 2.0
const CHARGE_THRESHOLD = 0.2
const CHARGE_RELEASE_THRESHOLD = 0.5

var magicBallResource = preload("res://game/projectiles/MagicBall.tscn")

var velocity

onready var global = get_node("/root/Global")
onready var bloodmoonStats = get_node("/root/BloodmoonStats")
onready var playerStats = get_node("/root/PlayerStats")


onready var head = $Head
onready var rayCast = $Head/RayCast
onready var rayCastClose = $Head/RayCastClose
onready var animationPlayer = $AnimationPlayer
onready var cameraAnimationPlayer = $Head/CameraAnimationPlayer
onready var sprite = $Head/Camera/Sprite3D
onready var blood = $Head/Blood
onready var deathscreen = $CanvasLayer/Control/YouDied
onready var healthbar = $CanvasLayer/Control/Health/Healthbar
onready var staminaBar = $CanvasLayer/Control/Stamina/StaminaBar
onready var manaBar = $CanvasLayer/Control/Mana/ManaBar
onready var crest1 = $CanvasLayer/Control/crests/Crest1
onready var crest2 = $CanvasLayer/Control/crests/Crest2
onready var crest3 = $CanvasLayer/Control/crests/Crest3
onready var moonLabel = $CanvasLayer/Control/Moons/Label
onready var tooltip = $CanvasLayer/Control/Pixelator/tooltip
onready var dialogue = $CanvasLayer/Control/Pixelator/Dialogue
onready var dialoguePlayer = $DialogueAnimationPlayer
onready var crosshair = $CanvasLayer/Control/Crosshair
onready var redkey = $CanvasLayer/Control/keys/redkey
onready var bluekey = $CanvasLayer/Control/keys/bluekey
onready var colorrect = $CanvasLayer/Control/ColorRect
onready var teleportAnimationPlayer = $EffectAnimationPlayer
onready var bossHealthAssembly = $CanvasLayer/Control/Boss
onready var bossHealthBar = $CanvasLayer/Control/Boss/BossHealth
onready var pauseMenu = $PauseMenu
onready var levelMenu = $LevelMenu
onready var mapMenu = $MapMenu
onready var bloodmoonLevelMenu = $BloodmoonLevelMenu
onready var roomLabel = $CanvasLayer/Control/Room/Roomlabel
onready var bloodmonLabel = $CanvasLayer/Control/Bloodmoon/Label

export var freezePlayer = false setget setFreezePlayer

func setFreezePlayer(f):
	freezePlayer = f

var dead = false
var level
var mouseSense = .0
var isBlocking = false
var chargeTime = .0
var isCharging = false
var chargePlayed = false
var currentSpeed = SPEED

func _ready():
	level = get_parent()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head.rotation = Vector3()
	head.translation.y = .25
	velocity = Vector3()
	freezePlayer = false
	deathscreen.frame = 0
	sprite.frame = 0
	updateHud()
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "setPlayer", self)
	get_tree().call_group("collectibles", "setPlayer", self)
	get_tree().call_group("interactables", "setPlayer", self)
	tooltip.text = ""
	clearDialogue()
	colorrect.color = Color(0,0,0,0)
	blood.emitting = false
	mouseSense = pauseMenu.sensSlider.value

func _input(event):
	if get_tree().paused:
		return
	
	if event is InputEventMouseMotion and !freezePlayer:
		rotation_degrees.y -= mouseSense * get_process_delta_time() * event.relative.x
		head.rotation_degrees.x = clamp(head.rotation_degrees.x - mouseSense * get_process_delta_time() * event.relative.y, -90, 90)

func _physics_process(delta):
	# System
	if Input.is_action_just_pressed("quit"):
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
	elif Input.is_action_just_pressed("reset") or (dead and Input.is_action_just_pressed("actualReset")):
		playerStats.health = playerStats.healthMax
		playerStats.stamina = playerStats.staminaMax
		playerStats.mana = playerStats.manaMax
		global.setBossHealth(global.bossHealthMax)
		global.resetPieces()
		global.inBossFight = false
		get_tree().change_scene("res://game/Levels/HubWorld.tscn")

	if dead or freezePlayer:
		return

	var target = rayCast.get_collider()
	if target:
		if target.has_method("getTooltip"):
			tooltip.text = target.getTooltip()
		if Input.is_action_just_pressed("use") and target.has_method("use"):
			target.use()
	elif tooltip.text != "":
		tooltip.text = ""
	
	if isIdle() or isBlocking or isCharging:
		if Input.is_action_just_pressed("attack"):
			isCharging = true
			chargeTime = 0.0
			chargePlayed = false

		elif Input.is_action_just_released("attack") and isCharging:
			if chargeTime < CHARGE_THRESHOLD:
				startSlash()
			elif chargeTime < CHARGE_RELEASE_THRESHOLD:
				animationPlayer.play("rightReturn")
			else:
				doStab() 
			isCharging = false
			currentSpeed = SPEED
		elif Input.is_action_just_pressed("kick") and not isCharging:
			doKick()
		elif Input.is_action_just_pressed("shoot") and not isCharging:
			doShoot()

	if isCharging:
		chargeTime += delta
		chargeTime = min(chargeTime, MAX_CHARGE_TIME)
		if chargeTime >= CHARGE_THRESHOLD and (!animationPlayer.is_playing() or isBlocking):
			addStamina(bloodmoonStats.getBlockCost() * delta)
			if !chargePlayed:
				animationPlayer.play("chargeStab")
				chargePlayed = true
				stopBlock()
				currentSpeed = 1

			
	if isIdle() and not isBlocking and not isCharging:
		addStamina(playerStats.staminaRecovery * delta)
		if Input.is_action_just_pressed("block"):
			doBlock()
			
	if isBlocking:
		addStamina(bloodmoonStats.getBlockCost() * delta)
		if Input.is_action_just_released("block") or not hasEnoughStamina(0.01):
			stopBlock()

	# Movement
	var moveVector = Vector3()
	if !freezePlayer:
		if Input.is_action_pressed("move_forward"):
			moveVector.z -= 1
		if Input.is_action_pressed("move_back"):
			moveVector.z += 1
		if Input.is_action_pressed("move_left"):
			moveVector.x -= 1
		if Input.is_action_pressed("move_right"):
			moveVector.x += 1

	moveVector = moveVector.normalized()
	moveVector = moveVector.rotated(Vector3(0, 1, 0), rotation.y)
	velocity = lerp(velocity, moveVector * currentSpeed, ACCEL * delta)

	move_and_slide(velocity)

# sword state machine

# future proofing in case I add an idle animation
func isIdle():
	return !animationPlayer.is_playing()
	
func startSlash():
	var staminaCost = 30
	if not hasEnoughStamina(staminaCost):
		return
	stopBlock()
	animationPlayer.play("slashWindup")

func chargeStab():
	animationPlayer.play("stab")

func doSlash(ret = false):
	var staminaCost = 30
	if not hasEnoughStamina(staminaCost):
		if ret:
			animationPlayer.play("rightReturn")
		return
	addStamina(-staminaCost)
	animationPlayer.play("slash")

func doStab():
	var staminaCost = 50
	addStamina(-staminaCost)
	animationPlayer.play("stab")

func doSlashBack(ret=false):
	var staminaCost = 30
	if not hasEnoughStamina(staminaCost):
		if ret:
			animationPlayer.play("leftReturn")
		return
	addStamina(-staminaCost)
	animationPlayer.play("slashBack")
	
func doBlock():
	if not hasEnoughStamina(20):
		stopBlock()
		return
	
	isBlocking = true
	currentSpeed = 1
	animationPlayer.play("block")
	
func doKick():
	var staminaCost = 20
	if not hasEnoughStamina(staminaCost):
		return
	stopBlock()
	animationPlayer.play("kick")
	addStamina(-staminaCost)

func doShoot():
	var staminaCost = 10
	var manaCost = 20
	if not hasEnoughStamina(staminaCost) or not hasEnoughMana(manaCost):
		return
	stopBlock()
	animationPlayer.play("shoot")
	addStamina(-staminaCost)
	addMana(-manaCost)
	
func stopBlock():
	isBlocking = false
	currentSpeed = SPEED
	sprite.frame = 0
	
func hasEnoughStamina(s):
	return playerStats.hasEnoughStamina(s)

func hasEnoughMana(m):
	return playerStats.hasEnoughMana(m)

func addHealth(h):
	playerStats.addHealth(h)
	updateHud()
	if playerStats.isDead():
		die()
	
func addStamina(s):
	playerStats.addStamina(s)
	updateHud()

func addMana(m):
	playerStats.addMana(m)
	updateHud()

func isHealthMax():
	return playerStats.isHealthMax()

func isManaMax():
	return playerStats.isManaMax()
	
func doSlashBackOrReturn():
	if Input.is_action_pressed("attack"):
		doSlashBack(true)
	elif Input.is_action_pressed("kick"):
		doKick()
	else:
		animationPlayer.play("leftReturn")

func doSlashOrReturn():
	if Input.is_action_pressed("attack"):
		doSlash(true)
	elif Input.is_action_pressed("kick"):
		doKick()
	else:
		animationPlayer.play("rightReturn")

func shoot():
	var direction = Vector3(0, 0, -1)
	direction = direction.rotated(Vector3(0, 1, 0), rotation.y)
	var magicBall = magicBallResource.instance()
	magicBall.translation = translation + direction * MAGICBALL_START_DISTANCE
	magicBall.translation.y = MAGICBALL_HEIGHT
	magicBall.setSource(self)
	magicBall.setVelocity(direction * MAGICBALL_SPEED)
	magicBall.setMagicDamage(playerStats.magicDamage)
	get_parent().get_parent().add_child(magicBall)
	animationPlayer.play("rightReturn")

func _on_SwordArea_area_entered(area):
	var target = area.get_parent()
	if target == self:
		return
	if target.has_method("slash"):
		target.slash(playerStats.physicalDamageSlash)

func _on_StabArea_area_entered(area:Area):
	var target = area.get_parent()
	if target == self:
		return
	if target.has_method("stab"):
		target.stab(playerStats.physicalDamageStab)

func _on_KickArea_area_entered(area):
	var target = area.get_parent()
	if target == self:
		return
	if target.has_method("kick"):
		target.kick(Vector3(0,0,-1).rotated(Vector3(0, 1, 0), rotation.y))

func tellBlockersToBlock():
	get_tree().call_group("blockers", "playerAttacking")
	

# outside effects:

# take damage
func damage(d: int):
	if dead:
		return
	
	if isBlocking:
		var staminaCost = 30
		addStamina(-staminaCost)
		return
		
	blood.amount = BLOOD_SCALE * d
	cameraAnimationPlayer.play("take_damage")
	
	addHealth(-d)

func die():
	dead = true
	blood.amount = BLOOD_SCALE * 100
	receiveMoons(10)
	animationPlayer.play("rightExit")
	cameraAnimationPlayer.play("die")

func pickupHealth():
	var potion_hp = playerStats.healthMax * bloodmoonStats.getPotionMultiplier()
	addHealth(potion_hp)
	playHealthPickupAnim()
	updateHud()

func pickupMana():
	var potion_mp = playerStats.manaMax * bloodmoonStats.getPotionMultiplier()
	addMana(potion_mp)
	playManaPickupAnim()
	updateHud()
	
func updateHud():
	crest1.visible = global.havePiece(0)
	crest2.visible = global.havePiece(1)
	crest3.visible = global.havePiece(2)
	redkey.visible = level.has_method("playerHasKey") and level.playerHasKey(0)
	bluekey.visible = level.has_method("playerHasKey") and level.playerHasKey(1)
	var hpPercent = playerStats.getHealthPercent()
	healthbar.rect_scale = Vector2(hpPercent, 1)
	var staminaPercent = playerStats.getStaminaPercent()
	staminaBar.rect_scale = Vector2(staminaPercent, 1)
	var manaPercent = playerStats.getManaPercent()
	manaBar.rect_scale = Vector2(manaPercent, 1)
	moonLabel.text = str(playerStats.moons)
	var bossHpPercent = float(global.bossHealth)/float(global.bossHealthMax)
	bossHealthBar.rect_scale = Vector2(bossHpPercent, 1)
	bloodmonLabel.text = str(bloodmoonStats.getBloodmoonLevel())
	if global.inBossFight:
		bossHealthAssembly.visible = true
	else:
		bossHealthAssembly.visible = false

func clearDialogue():
	dialogue.visible = false
	dialogue.text = ""
	crosshair.visible = true

func playDialogue(s):
	dialogue.percent_visible = 0
	dialogue.text = s
	crosshair.visible = false
	dialogue.visible = true
	dialoguePlayer.play("print")

func receiveMoons(m):
	playerStats.addMoons(m)

func resetLevels():
	playerStats.resetLevels()

func openLevelMenu():
	levelMenu.openLevelMenu()

func openBloodmoonLevelMenu():
	bloodmoonLevelMenu.openLevelMenu()

func teleportHome():
	teleportAnimationPlayer.play("teleport")
	
func fadeIn():
	teleportAnimationPlayer.play("fadein")
	
func fadeToFinish():
	teleportAnimationPlayer.play("fadeToFinish")

func doFinish():
	get_tree().change_scene("res://game/Cutscenes/Outro.tscn")

func doTeleport():
	get_tree().change_scene("res://game/Levels/HubWorld.tscn")
	
func playHealthPickupAnim():
	cameraAnimationPlayer.play("healthpickup")

func playManaPickupAnim():
	cameraAnimationPlayer.play("manapickup")

func setMap(p):
	mapMenu.setMap(p)

func setGoal(g):
	mapMenu.setGoal(g)

func setRoom(r):
	roomLabel.text = r

func _on_PauseMenu_senseChanged(value):
	mouseSense = value 
