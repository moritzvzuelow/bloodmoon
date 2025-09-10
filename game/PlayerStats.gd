extends Node

const BASE_HEALTH = 100
const BASE_STAMINA = 100
const BASE_MANA = 100
const BASE_PHYSICAL_DAMAGE = 5
const BASE_MAGICAL_DAMAGE = 10

# levelpoints
var healthLevel = 0
var staminaLevel = 0 
var manaLevel = 0 
var strengthLevel = 0
var magicLevel = 0
var remainingLevelPoints = 10

# max Character Stats
var healthMax = BASE_HEALTH
var staminaMax = BASE_STAMINA
var manaMax = BASE_MANA

#character stats
var health = healthMax
var stamina = staminaMax
var mana = manaMax
var physicalDamage = 0.2 * strengthLevel
var magicDamage = 0.2 * magicLevel


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

func getHealthPercent():
	return float(health)/float(healthMax)

func getStaminaPercent():
	return float(stamina)/float(staminaMax)

func getManaPercent():
	return float(mana)/float(manaMax)

func updateHealthMax():
	healthMax = BASE_HEALTH + healthLevel * 20

func updateStaminaMax():
	staminaMax = BASE_STAMINA + staminaLevel * 20

func updateManaMax():
	manaMax = BASE_MANA + manaLevel * 20

func updatePhysicalDamage():
	physicalDamage = BASE_PHYSICAL_DAMAGE + 0.2 * BASE_PHYSICAL_DAMAGE * strengthLevel

func updateMagicDamage():
	magicDamage = BASE_MAGICAL_DAMAGE + 0.2 * BASE_MAGICAL_DAMAGE * magicLevel
