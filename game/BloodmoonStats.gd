extends Node

const healingMap = {
	0: 0,
	1: 0.25,
	2: 0.33,
	3: 0.5
}

const potionHealingMap = {
	0: 0.66,
	1: 0.5,
	2: 0.33,
	3: 0.25
}

const levelLimitMap = {
	0: 100,
	1: 75,
	2: 50,
	3: 25
}

const blockStaminaMap = {
	0: 30,
	1: 100,
	2: 175,
	3: 250
}

var enemyHealthLevel = 0
var enemyDamageLevel = 0
var enemyHealingLevel = 0
var potionDebuffLevel = 0
var levelLimitLevel = 0
var blockDurationLimitLevel = 0

var conquered = true
var highestConquered = 14

func getBloodmoonLevel():
	return enemyHealthLevel + enemyDamageLevel + enemyHealingLevel + potionDebuffLevel + levelLimitLevel + blockDurationLimitLevel

func getHealingAmount(maxHealth):
	return maxHealth * healingMap.get(enemyHealingLevel, 0)

func getPotionMultiplier():
	return potionHealingMap.get(potionDebuffLevel, 0.66) 

func getLevelLimit():
	return levelLimitMap.get(levelLimitLevel, 100)

func getBlockCost():
	return -blockStaminaMap.get(blockDurationLimitLevel, 30)

func updateHighestConquered():
	if getBloodmoonLevel() > 0:
		conquered = true
		highestConquered = max(highestConquered, getBloodmoonLevel())

func getBloodmoonDescription():
	if not conquered:
		return "Git Gud(0)"
	var desc = ""
	if 2 <= highestConquered and highestConquered <= 5:
		desc = "NOOB"
	elif 6 <= highestConquered and highestConquered <= 9:
		desc = "PRO"
	elif 10 <= highestConquered and highestConquered <= 13:
		desc = "BEAST"
	elif 14 <= highestConquered and highestConquered <= 17:
		desc = "LEGEND"
	else:
		desc = "GOD"
	return "%d (%s)" % [highestConquered, desc]
