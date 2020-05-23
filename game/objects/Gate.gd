extends Node2D

var count = 0
export(String) var nextLevel
export(int) var neededCount
signal gate_open

func _ready():
	var switches = get_parent().get_node("Switches")
	for switch in switches.get_children():
		switch.connect("switch_signal", self, "_on_switch_signal")

func _on_switch_signal():
	count += 1
	if count == neededCount:
		self.visible = true
		get_parent().get_node("Player").on_gate_open()

func _on_Area2D_body_entered(body):
	if count == neededCount:
		$InteractPrompt.visible = true
		if body.has_method("setInteractable"):
			body.setInteractable(self);

func _on_Area2D_body_exited(body):
	body.setInteractable(null);

func interact():
	if count == neededCount:
		get_tree().change_scene(nextLevel)
