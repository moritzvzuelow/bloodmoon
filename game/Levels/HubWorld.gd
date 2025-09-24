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
	"WIZARD NODROG: Left-click to swing your sword.\nRight-click to kick and stun your enemies.",
	"WIZARD NODROG: Press SPACE to open doors.  Or just kick them down.",
	"WIZARD NODROG: Now go, and destroy LICH NUR."
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
		animationPlayer.play("delay")
	if true in global.piece:
		cabinet.queue_free()

func showNextSlide():
	if tutorialLine < tutorialText.size():
		animationPlayer.play("tutorial")

func showSlide():
	player.playDialogue(tutorialText[tutorialLine])
	kyle.stream = load(kyleAudio[tutorialLine])
	kyle.playing = true
	tutorialLine += 1

func _on_HubRoomArea_area_entered(_area:Area):
	player.setRoom("Hub")
