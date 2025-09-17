extends Node

onready var bloodmoonStats = get_node("/root/BloodmoonStats")

const BASE_HEALTH = 100
const BASE_STAMINA = 100
const BASE_MANA = 100
const BASE_PHYSICAL_DAMAGE_SLASH = 5
const BASE_PHYSICAL_DAMAGE_STAB = 10
const BASE_MAGICAL_DAMAGE = 10

const BASE_LEVELUP_COST = 100

# levelpoints
var healthLevel = 20
var staminaLevel = 20 
var manaLevel = 20 
var strengthLevel = 20
var magicLevel = 20
var remainingLevelPointsMax = 90
var remainingLevelPoints = remainingLevelPointsMax

# max Character Stats
var healthMax = BASE_HEALTH + healthLevel * 20
var staminaMax = BASE_STAMINA + staminaLevel * 20
var manaMax = BASE_MANA + manaLevel * 20

#character stats
var health = healthMax
var stamina = staminaMax
var mana = manaMax
var physicalDamageSlash = BASE_PHYSICAL_DAMAGE_SLASH + 2 * strengthLevel
var physicalDamageStab = BASE_PHYSICAL_DAMAGE_STAB + 4 * strengthLevel
var magicDamage = BASE_MAGICAL_DAMAGE + 4 * magicLevel

var staminaRecovery = staminaMax * 0.3

var levelup_cost = BASE_LEVELUP_COST
var moons = 150


func hasEnoughStamina(s):
	return stamina >= s

func hasEnoughMana(m):
	return mana >= m

func addHealth(h):
	health += h
	health = clamp(health, 0, healthMax)
	
func isDead():
	return health == 0
	
func addStamina(s):
	stamina += s
	stamina = clamp(stamina, 0, staminaMax)

func addMana(m):
	mana += m
	mana = clamp(mana, 0, manaMax)

func addMoons(m):
	moons += m
	moons = clamp(moons, 0, 999999)

func getHealthPercent():
	return float(health)/float(healthMax)

func getStaminaPercent():
	return float(stamina)/float(staminaMax)

func getManaPercent():
	return float(mana)/float(manaMax)

func updateRemainingLevels(toAdd):
	remainingLevelPointsMax += toAdd
	remainingLevelPoints = clamp(remainingLevelPoints + toAdd, 0, bloodmoonStats.getLevelLimit())

func updateHealthMax():
	var toAdd = healthLevel * 20
	var healthPercent = getHealthPercent()
	healthMax = BASE_HEALTH + toAdd
	health = int(healthPercent * healthMax)

func updateStaminaMax():
	var toAdd = staminaLevel * 20
	var staminaPercent = getStaminaPercent()
	staminaMax = BASE_STAMINA + toAdd
	stamina = int(staminaPercent * staminaMax)
	staminaRecovery = staminaMax * 0.3

func updateManaMax():
	var toAdd = manaLevel * 20
	var manaPercent = getManaPercent()
	manaMax = BASE_MANA + toAdd
	mana = int(manaPercent * manaMax)

func updatePhysicalDamage():
	physicalDamageSlash = BASE_PHYSICAL_DAMAGE_SLASH + 2 * strengthLevel
	physicalDamageStab = BASE_PHYSICAL_DAMAGE_STAB + 4 * strengthLevel

func updateMagicDamage():
	magicDamage = BASE_MAGICAL_DAMAGE + 4 * magicLevel

func levelUpPossible():
	return moons >= levelup_cost

func levelup():
	if not levelUpPossible():
		return
	updateRemainingLevels(1)
	moons -= levelup_cost
	levelup_cost = int(levelup_cost * 1.5)

func isHealthMax():
	return health == healthMax

func isManaMax():
	return mana == manaMax

func resetLevels():
	remainingLevelPoints = clamp(remainingLevelPointsMax, 0, bloodmoonStats.getLevelLimit())
	healthLevel = 0
	staminaLevel = 0
	manaLevel = 0
	strengthLevel = 0
	magicLevel = 0
