extends Node2D

export var life := 100

func damage(points: int):
	if life - points > 0:
		life -= points
	else:
		life = 0

func _ready():
	pass
