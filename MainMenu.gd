extends MarginContainer

#Manually connects button to start script
func _ready():
	for button in $HBoxContainer/VBoxContainer/MenuOptions.get_children():
			button.connect("pressed", self, "_on_button_pressed", [button.scene_to_load])

#TODO: CHANGE BACK TO SCENE_TO_LOAD ONCE YOU HAVE ALL THREE SCENES
func _on_button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)
