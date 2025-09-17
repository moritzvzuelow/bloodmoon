extends Node

const healingMap = {
	0: 0,
	1: 0.25,
	2: 0.33,
	3: 0.5
}

var enemyHealthLevel = 0
var enemyDamageLevel = 0
var enemyHealingLevel = 2
var potionDebuffLevel = 0
var levelLimitLevel = 0
var blockDurationLimitLevel = 0

func getBloodmoonLevel():
	return enemyHealthLevel + enemyDamageLevel + enemyHealingLevel + potionDebuffLevel + levelLimitLevel + blockDurationLimitLevel

func getHealingAmount(maxHealth):
	return maxHealth * healingMap.get(enemyHealingLevel, 0)
