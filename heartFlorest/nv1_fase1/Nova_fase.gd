extends Area2D


func _on_Area2D4_body_entered(body):
	print("Carrega cena");
	get_tree().change_scene("res://nv2_fase2/Node2D.tscn");
