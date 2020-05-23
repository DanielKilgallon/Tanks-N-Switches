extends Node2D

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		body.set_global_position(Vector2(25.0, -120.0))
