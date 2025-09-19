extends Node

# GLOBAL GAME STATE SINGLETON FILE

# Global Vars
export var bossHealthMax = 100 setget setBossHealthMax
export var bossHealth = 100 setget setBossHealth
var piece = [false, false, false]
var tutorialDone = false
var inBossFight = false
export var particlesEnabled = true
var bossAlreadyFought = true

func setBossHealth(h):
	bossHealth = h

func setBossHealthMax(h):
	bossHealthMax = h

func damageBoss(d):
	bossHealth = clamp(bossHealth - d, 0, bossHealthMax)

func getPiece(n):
	piece[n] = true

func havePiece(n):
	return piece[n]

func resetPieces():
	piece = [false, false, false]
