extends Node2D

func _ready():
	Hud.get_node("CanvasLayer/TextureProgress").visible = true
	GameManager.frequency = 1000
