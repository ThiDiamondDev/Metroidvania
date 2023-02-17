extends Node2D

onready var background :ParallaxBackground = $ParallaxBackground
onready var player = $Player

func _process(_delta):
	print(background.position)