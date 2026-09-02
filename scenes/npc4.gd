extends CharacterBody2D

const SPEED = 80.0

var current_state = IDLE 

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

var move_time = 0.0

enum{
	IDLE,
	MOVE
}

func _ready():
	randomize()
	start_pos = position

func _process(delta):

	# 🎮 Animation
	if current_state == IDLE:
		$AnimatedSprite2D.play("idle")

	elif current_state == MOVE and !is_chatting:
		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				$AnimatedSprite2D.play("walk_right")
			else:
				$AnimatedSprite2D.play("walk_left")
		else:
			if dir.y > 0:
				$AnimatedSprite2D.play("walk_back")
			else:
				$AnimatedSprite2D.play("walk_front")

	# 🚶 Roaming logic
	if is_roaming:
		move_time -= delta

		if move_time <= 0:
			current_state = choose([IDLE, MOVE])

			if current_state == MOVE:
				dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
				move_time = randf_range(1.5, 3.0)
			else:
				move_time = randf_range(1.0, 2.0)

		if current_state == MOVE:
			move(delta)

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if is_chatting:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	velocity = dir * SPEED
	move_and_slide()

	# 🔥 Smart collision handling
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		dir = dir.bounce(collision.get_normal()).normalized()

		# reset movement time so it doesn't instantly change again
		move_time = randf_range(1.0, 2.0)

func _on_chat_detection_body_entered(body: Node2D) -> void:
	if body.name == "playerr":
		player = body
		player_in_chat_zone = true

func _on_chat_detection_body_exited(body: Node2D) -> void:
	if body.name == "playerr":
		player_in_chat_zone = false
