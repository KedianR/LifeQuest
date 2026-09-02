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

# 💬 NPC Dialogue
var npc_name = "RUBY   :   "
var npc_message = "  Be careful dear."

# 💬 Textbox system
var chat_box = null
@export var textbox_scene: PackedScene

enum {
	IDLE,
	MOVE
}

func _ready():
	randomize()
	start_pos = position

func _process(delta):

	# 🔥 Auto close if player leaves
	if !player_in_chat_zone and is_chatting:
		end_chat()

	# 💬 Press key to chat
	if player_in_chat_zone and Input.is_action_just_pressed("interact"):
		if not is_chatting:
			start_chat()
		else:
			end_chat()

	# 🎮 Animation
	if current_state == IDLE or is_chatting:
		$AnimatedSprite2D.play("idle")
	elif current_state == MOVE:
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

	# 🚶 Roaming
	if is_roaming and not is_chatting:
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

func start_chat():
	is_chatting = true
	is_roaming = false
	velocity = Vector2.ZERO
	current_state = IDLE

	chat_box = textbox_scene.instantiate()
	get_tree().root.add_child(chat_box)

	chat_box.start_chat(npc_name, npc_message)

func end_chat():
	is_chatting = false
	is_roaming = true

	if chat_box != null:
		chat_box.queue_free()
		chat_box = null

func choose(array):
	array.shuffle()
	return array.front()

func move(_delta):
	if is_chatting:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	velocity = dir * SPEED
	move_and_slide()

	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		dir = dir.bounce(collision.get_normal()).normalized()
		move_time = randf_range(1.0, 2.0)

# ✅ CORRECT DETECTION (THIS WAS YOUR BUG)
func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "playerr":
		player = body
		player_in_chat_zone = true

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "playerr":
		player_in_chat_zone = false
