extends KinematicBody2D

const jumpvelocity = 120
const gravityscale = 7
var walkspeed = 80
const friction = 0.1
const acceleration = 0.25
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var can_jump = false
var coyoteCount = 0
var rotated = false

var labelAlpha = 0

var localInteractable

func _input(event):
	emote(event)
	interactWithObject()

func _physics_process(_delta):
	velocity.x = 0
	velocity.y += gravityscale
	
	if $RightRay.is_colliding():
		var rnormal = $RightRay.get_collision_normal()
		if rnormal.x > -0.75 and rnormal.x < -0.67:
			rotatePlayer("right")
	elif $LeftRay.is_colliding():
		var lnormal = $LeftRay.get_collision_normal()
		if lnormal.x < 0.75 and lnormal.x > 0.67:
			rotatePlayer("left")
	else:
		rotatePlayer("")

	if Input.is_action_pressed("right"):
		velocity.x = walkspeed
		$TankTop/Particles2D.position = Vector2(-2.5,-6.25)
		$TankTop/Particles2D.emitting = true
		$TankBot.play()
		$TankTop.play("Walk")
		$TankBot.flip_h = false
		$TankTop.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -walkspeed
		$TankTop/Particles2D.position = Vector2(2.5,-6.25)
		$TankTop/Particles2D.emitting = true
		$TankBot.play()
		$TankTop.play("Walk")
		$TankBot.flip_h = true
		$TankTop.flip_h = true
	else:
		$TankBot.stop()
		$TankTop.play("Idle")
	
	if is_on_floor():
		can_jump = true
		coyoteCount = 0
	else:
		coyoteCount += 1
		if coyoteCount > 5:
			can_jump = false
	
	if can_jump && Input.is_action_just_pressed("jump"):
		can_jump = false
		velocity.y = -jumpvelocity

	var snap = Vector2.DOWN * 32 if !can_jump else Vector2.ZERO

	#returns a normalized velocity so the y value
	#doesn't get FUCKING ENORMOUS
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR)

func setInteractable(interactable):
	localInteractable = interactable

func interactWithObject():
	if localInteractable != null and localInteractable.has_method("interact") and Input.is_action_just_released("interact"):
		localInteractable.interact()

func emote(event):
	if event.is_action_pressed("down"):
		$emote.visible = false
	elif event.is_action_pressed("up"):
		$emote.visible = true
		var number = str(randi() % 29)
		if number.length() < 2:
			number = "0" + number
		var emote = load("res://assets/sprites/emotes/sprite_emotes"+number+".png")
		$emote.texture = emote

func rotatePlayer(dir):
	if dir == "right":
		if !rotated:
			walkspeed = 60
			$TankBot.rotate(-PI / 4)
			$TankTop.rotate(-PI / 4)
			rotated = true
	elif dir == "left":
		if !rotated:
			walkspeed = 60
			$TankBot.rotate(PI / 4)
			$TankTop.rotate(PI / 4)
			rotated = true
	else:
		if rotated:
			walkspeed = 80
			$TankBot.rotation = 0
			$TankTop.rotation = 0
			rotated = false

func on_gate_open():
	$Label.add_color_override("font_color", Color(255, 255, 255, 0))
	$Label.visible = true
	$LabelFadeIn.start()
	$WaitStartFadeOut.start()

func _on_FadeIn_timeout():
	labelAlpha += .05
	$Label.add_color_override("font_color", Color(255, 255, 255, labelAlpha))

func _on_WaitStartFadeOut_timeout():
	$LabelFadeIn.stop()
	$LabelFadeOut.start()

func _on_FadeOut_timeout():
	labelAlpha -= .05
	$Label.add_color_override("font_color", Color(255, 255, 255, labelAlpha))
	if labelAlpha < 0:
		$LabelFadeOut.stop()
