extends Area2D

func _on_mall_body_entered(body):
	print("ENTERED:", body.name)

	if body.name == "playerr":
		print("GOING TO MALL")
		get_tree().change_scene_to_file("res://scenes/levels/mall_map.tscn")
