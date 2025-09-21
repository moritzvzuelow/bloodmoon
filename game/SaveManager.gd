extends Node

onready var global = get_node("/root/Global")
onready var bloodmoonStats = get_node("/root/BloodmoonStats")
onready var playerStats = get_node("/root/PlayerStats")

var savePath = "user://savegame.json"

func save():
    var data = {
        "introSeen": global.introSeen,
        "piece": global.piece,
        "tutorialDone": global.tutorialDone,
        "inBossFight": global.inBossFight,
        "particlesEnabled": global.particlesEnabled,
        "bossAlreadyFought": global.bossAlreadyFought,
        "enemyHealthLevel": bloodmoonStats.enemyHealthLevel,
        "enemyDamageLevel": bloodmoonStats.enemyDamageLevel,
        "enemyHealingLevel": bloodmoonStats.enemyHealingLevel,
        "potionDebuffLevel": bloodmoonStats.potionDebuffLevel,
        "levelLimitLevel": bloodmoonStats.levelLimitLevel,
        "blockDurationLimitLevel": bloodmoonStats.blockDurationLimitLevel,
        "conquered": bloodmoonStats.conquered,
        "highestConquered": bloodmoonStats.highestConquered,
        "healthLevel": playerStats.healthLevel,
        "staminaLevel": playerStats.staminaLevel,
        "manaLevel": playerStats.manaLevel,
        "strengthLevel": playerStats.strengthLevel,
        "magicLevel": playerStats.magicLevel,
        "remainingLevelPointsMax": playerStats.remainingLevelPointsMax,
        "remainingLevelPoints": playerStats.remainingLevelPoints,
        "healthMax": playerStats.healthMax,
        "staminaMax": playerStats.staminaMax,
        "manaMax": playerStats.manaMax,
        "health": playerStats.health,
        "stamina": playerStats.stamina,
        "mana": playerStats.mana,
        "physicalDamageSlash": playerStats.physicalDamageSlash,
        "physicalDamageStab": playerStats.physicalDamageStab,
        "magicDamage": playerStats.magicDamage,
        "staminaRecovery": playerStats.staminaRecovery,
        "levelUpCost": playerStats.levelup_cost,
        "moons": playerStats.moons
    }

    var file = File.new()
    if file.open(savePath, File.WRITE) == OK:
        file.store_string(to_json(data))
        file.close()

func load():
    var file = File.new()
    if not file.file_exists(savePath):
        return

    if file.open(savePath, File.READ) == OK:
        var data = parse_json(file.get_as_text())
        file.close()

        if typeof(data) == TYPE_DICTIONARY:
            global.introSeen = data["introSeen"]
            global.piece = data["piece"]
            global.tutorialDone = data["tutorialDone"]
            global.inBossFight = data["inBossFight"]
            global.particlesEnabled = data["particlesEnabled"]
            global.bossAlreadyFought = data["bossAlreadyFought"]
            bloodmoonStats.enemyHealthLevel = data["enemyHealthLevel"]
            bloodmoonStats.enemyDamageLevel = data["enemyDamageLevel"]
            bloodmoonStats.enemyHealingLevel = data["enemyHealingLevel"]
            bloodmoonStats.potionDebuffLevel = data["potionDebuffLevel"]
            bloodmoonStats.levelLimitLevel = data["levelLimitLevel"]
            bloodmoonStats.blockDurationLimitLevel = data["blockDurationLimitLevel"]
            bloodmoonStats.conquered = data["conquered"]
            bloodmoonStats.highestConquered = data["highestConquered"]
            playerStats.healthLevel = data["healthLevel"]
            playerStats.staminaLevel = data["staminaLevel"]
            playerStats.manaLevel = data["manaLevel"]
            playerStats.strengthLevel = data["strengthLevel"]
            playerStats.magicLevel = data["magicLevel"]
            playerStats.remainingLevelPointsMax = data["remainingLevelPointsMax"]
            playerStats.remainingLevelPoints = data["remainingLevelPoints"]
            playerStats.healthMax = data["healthMax"]
            playerStats.staminaMax = data["staminaMax"]
            playerStats.manaMax = data["manaMax"]
            playerStats.health = data["health"]
            playerStats.stamina = data["stamina"]
            playerStats.mana = data["mana"]
            playerStats.physicalDamageSlash = data["physicalDamageSlash"]
            playerStats.physicalDamageStab = data["physicalDamageStab"]
            playerStats.magicDamage = data["magicDamage"]
            playerStats.staminaRecovery = data["staminaRecovery"]
            playerStats.levelup_cost = data["levelUpCost"]
            playerStats.moons = data["moons"]

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		print("quit and save")
		save()
		get_tree().quit()
