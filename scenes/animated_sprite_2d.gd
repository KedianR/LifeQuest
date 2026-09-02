extends CharacterBody2D

const SPEED = 300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	process_movement()
	move_and_slide()
	update_animation()

func process_movement() -> void:
	var direction = Vector2.ZERO
	
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		last_direction = direction
	
	velocity = direction * SPEED

func update_animation() -> void:
	if velocity == Vector2.ZERO:
		play_idle_animation()
	else:
		play_run_animation()

func play_idle_animation() -> void:
	if last_direction.x > 0:
		animated_sprite.play("right")
	elif last_direction.x < 0:
		animated_sprite.play("left")
	elif last_direction.y > 0:
		animated_sprite.play("down")
	elif last_direction.y < 0:
		animated_sprite.play("up")

func play_run_animation() -> void:
	if velocity.x > 0:
		animated_sprite.play("run_right")
	elif velocity.x < 0:
		animated_sprite.play("run_left")
	elif velocity.y > 0:
		animated_sprite.play("run_down")
	elif velocity.y < 0:
		animated_sprite.play("run_up")
