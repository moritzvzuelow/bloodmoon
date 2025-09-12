extends Node

# GLOBAL GAME STATE SINGLETON FILE

# Constants
const BOSS_MAX_HP = 100

# Global Vars
export var bossHealth = 100 setget setBossHealth
var piece = [false, false, false]
var tutorialDone = false
var inBossFight = false
export var particlesEnabled = true

func setBossHealth(h):
	bossHealth = h

func getPiece(n):
	piece[n] = true

func havePiece(n):
	return piece[n]

func resetPieces():
	piece = [false, false, false]
