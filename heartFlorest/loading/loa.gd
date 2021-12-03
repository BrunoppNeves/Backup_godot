extends CanvasLayer

func _process(delta):
	yield(get_tree().create_timer(5.0),"timeout");
	get_tree().change_scene("res://nv2_fase2/Node2D.tscn");
