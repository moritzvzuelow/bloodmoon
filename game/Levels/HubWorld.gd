extends Spatial

const MAP_PATH = "res://assets/minimap_screenshots/hubworld_mm_cropped.png"

const goal = "Surpass 3 challenges to find 3 crests"

onready var player = $Player
onready var global = get_node("/root/Global")
onready var animationPlayer = $AnimationPlayer
onready var kyle = $AudioStreamPlayer2
onready var cabinet = $cabinet

const tutorialText = [
	"WIZARD NODROG: Welcome back, PALADIN.\nLICH NUR is imprisoned in CASTLE BLOODMOON, behind me",
	"WIZARD NODROG: You must recover the three pieces of the PALADIN CREST, and use them to enter the Castle.",
	"WIZARD NODROG: No doubt you are disoriented after being dead for so long.  Allow me to refresh you.",
	"WIZARD NODROG: Use W,A,S, and D to move, and the mouse to look around.",
	"WIZARD NODROG: Left-click to swing your sword.\nF (NOT Right-click!) to kick and stun your enemies.",
	"WIZARD NODROG: Press E (NOT SPACE!) to open doors.  Or just kick them down.",
	"WIZARD NODROG: Now go, and destroy LICH NUR.",
	"WIZARD NODROG: HOLD ON: THERE IS NEW OR CHANGED STUFF:",
	"WIZARD NODROG: Hold Left-Click for a heavy attack.\nPress Q to shoot Magic.",
	"WIZARD NODROG: Right Click to block all incoming damage.\nM to see the map and the goal.",
	"WIZARD NODROG: You can see the controls in the pause menu",
	"WIZARD NODROG: HAVE FUN."
]

const kyleAudio = [
	"res://assets/audio/wizard/tut0.wav",
	"res://assets/audio/wizard/tut1.wav",
	"res://assets/audio/wizard/tut2.wav",
	"res://assets/audio/wizard/tut3.wav",
	"res://assets/audio/wizard/tut4.wav",
	"res://assets/audio/wizard/tut5.wav",
	"res://assets/audio/wizard/tut6.wav",
]

var tutorialLine = 0

func _ready():
	player.setGoal(goal)
	player.setMap(MAP_PATH)
	player.fadeIn()
	if !global.tutorialDone:
		global.tutorialDone = true
		player.setFreezePlayer(true)
		animationPlayer.play("delay")
	if true in global.piece:
		cabinet.queue_free()

func showNextSlide():
	if tutorialLine < tutorialText.size():
		animationPlayer.play("tutorial")
	else:
		player.setFreezePlayer(false)
		global.tutorialDone = true

func showSlide():
	player.playDialogue(tutorialText[tutorialLine])
	if tutorialLine < kyleAudio.size():
		kyle.stream = load(kyleAudio[tutorialLine])
		kyle.playing = true
	else:
		kyle.playing = false
	tutorialLine += 1

func _on_HubRoomArea_area_entered(_area:Area):
	player.setRoom("Hub")
