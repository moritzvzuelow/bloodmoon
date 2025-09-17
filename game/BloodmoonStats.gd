extends Node

var enemyHealthLevel = 0
var enemyDamageLevel = 0
var enemyHealingLevel = 0
var potionDebuffLevel = 0
var levelLimitLevel = 0
var blockDurationLimitLevel = 0

func getBloodmoonLevel():
	return enemyHealthLevel + enemyDamageLevel + enemyHealingLevel + potionDebuffLevel + levelLimitLevel + blockDurationLimitLevel
