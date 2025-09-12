extends Node

const BASE_HEALTH = 100
const BASE_STAMINA = 100
const BASE_MANA = 100
const BASE_PHYSICAL_DAMAGE = 5
const BASE_MAGICAL_DAMAGE = 10

const LEVELUP_COST = 100

# levelpoints
var healthLevel = 10
var staminaLevel = 10 
var manaLevel = 10 
var strengthLevel = 10
var magicLevel = 10
var remainingLevelPoints = 10

# max Character Stats
var healthMax = BASE_HEALTH + healthLevel * 20
var staminaMax = BASE_STAMINA + staminaLevel * 20
var manaMax = BASE_MANA + manaLevel * 20

#character stats
var health = healthMax
var stamina = staminaMax
var mana = manaMax
var physicalDamage = BASE_PHYSICAL_DAMAGE + 0.2 * strengthLevel
var magicDamage = BASE_MAGICAL_DAMAGE + 0.2 * magicLevel

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

func updateManaMax():
	var toAdd = manaLevel * 20
	var manaPercent = getManaPercent()
	manaMax = BASE_MANA + toAdd
	mana = int(manaPercent * manaMax)

func updatePhysicalDamage():
	physicalDamage = BASE_PHYSICAL_DAMAGE + 0.2 * BASE_PHYSICAL_DAMAGE * strengthLevel

func updateMagicDamage():
	magicDamage = BASE_MAGICAL_DAMAGE + 0.2 * BASE_MAGICAL_DAMAGE * magicLevel

func levelUpPossible():
	return moons >= LEVELUP_COST

func levelup():
	if not levelUpPossible():
		return
	remainingLevelPoints += 1
	moons -= LEVELUP_COST

func isHealthMax():
	return health == healthMax

func isManaMax():
	return mana == manaMax
