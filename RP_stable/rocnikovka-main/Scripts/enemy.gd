extends Node2D

@onready var anim = $CharacterBody2D/AnimatedSprite2D

func _ready():
	anim.play("move")
