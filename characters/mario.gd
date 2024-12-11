extends CharacterBody2D

@export var speed = 300
@export var jump_force= 700
var gravity = 30
var acceleration = 500
var deceleration = 1000

func _ready():
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()

func _physics_process(delta: float):
	var horizontal_direction = Input.get_axis("left", "right")
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	else:
		if Input.is_action_just_pressed("up") && is_on_floor():
				velocity.y = -jump_force
				$AudioStreamPlayer2D.play()
	if horizontal_direction != 0:
		velocity.x = lerp(velocity.x, speed * horizontal_direction, acceleration * delta / speed)
		if Input.is_action_pressed("speed_up"):
			velocity.x = lerp(velocity.x, (speed * horizontal_direction) * 2.5, acceleration * delta / speed)
	else:
		velocity.x = lerp(velocity.x, 0.00, deceleration * delta / speed)
		if abs(velocity.x) < 35:
			velocity.x = 0
	player_animation(delta)
	move_and_slide()

func player_animation(delta):
	var state = $AnimatedSprite2D.animation
	if velocity.length() == 0:
		$AnimatedSprite2D.animation = "idle"
		
	if abs(velocity.x) > 400:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = velocity.x > 0
	elif velocity.x != 0 && is_on_floor():
		$AnimatedSprite2D.animation = "walk"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "jump"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "fall"
		
	if Input.is_action_pressed("down"):
		$AnimatedSprite2D.animation = "duck"
		velocity.y += gravity * 0.4
		if is_on_floor():
			velocity.x = 0
			
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x > 0
	
func _process(delta: float):
	position += velocity * delta
