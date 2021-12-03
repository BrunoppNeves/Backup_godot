extends Node2D

func _ready():
	pass
	
func _process(delta):
	$CanvasLayer/TextureProgress.value = GameManager.player_life
