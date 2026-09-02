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

# 💬 NPC4 SHORT DIALOGUE
var npc_name = "CLIENT   :   "
var npc_message = "Deliver fast."

# 💬 Textbox
var textbox_instance = null
@export var textbox_scene: PackedScene   # drag textbox.tscn here

enum{
	IDLE,
	MOVE
}

func _ready():
	randomize()
	start_pos = position

func _process(delta):

	# 💬 CHAT INPUT
	if player_in_chat_zone and Input.is_action_just_pressed("ui_accept"):
		if !is_chatting:
			start_chat()
		else:
			end_chat()

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
	if is_roaming and !is_chatting:
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

# 💬 START CHAT
func start_chat():
	is_chatting = true
	is_roaming = false
	current_state = IDLE

	textbox_instance = textbox_scene.instantiate()
	get_tree().root.add_child(textbox_instance)

	# ✅ SHOW MESSAGE
	textbox_instance.start_chat(npc_name, npc_message)

# 💬 END CHAT
func end_chat():
	is_chatting = false
	is_roaming = true

	if textbox_instance != null:
		textbox_instance.queue_free()
		textbox_instance = null

# 📡 DETECTION
func _on_chat_detection_body_entered(body: Node2D) -> void:
	if body.name == "playerr":
		player = body
		player_in_chat_zone = true

func _on_chat_detection_body_exited(body: Node2D) -> void:
	if body.name == "playerr":
		player_in_chat_zone = false
		end_chat()   # auto close

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "playerr":
		player = body
		player_in_chat_zone = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "playerr":
		player_in_chat_zone = false
		end_chat()
