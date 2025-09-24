extends Node2D

onready var moonLabel = $Label
onready var particles = $CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	particles.emitting = false


func setLabelText(t):
	moonLabel.text = str(t)

func startEmitting():
	particles.restart()
	particles.one_shot = false
	particles.emitting = true

func stopEmitting():
	particles.emitting = false

func oneShot():
	particles.restart()
	particles.one_shot = true
	particles.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
