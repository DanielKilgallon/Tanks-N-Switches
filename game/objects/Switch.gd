extends Node2D

signal switch_signal
export(String) var switch_color
var is_toggled = false

func _ready():
	$AnimatedSprite.animation = switch_color 

func interact():
	if !is_toggled:
		is_toggled = true
		$AnimatedSprite.play()
		$AudioStreamPlayer.play()
		emit_signal("switch_signal")

func _on_Area2D_body_entered(body):
	if body.has_method("setInteractable"):
		body.setInteractable(self)
		$InteractPrompt.visible = true

func _on_Area2D_body_exited(body):
	if body.has_method("setInteractable"):
		body.setInteractable(null)
		$InteractPrompt.visible = false
