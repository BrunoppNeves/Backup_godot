extends CanvasLayer

func _process(delta):
	Hud.get_node("CanvasLayer/TextureProgress").visible = false
	yield(get_tree().create_timer(10.0),"timeout");
	get_tree().change_scene("res://Menu");
