extends CharacterBody2D
var player_in_range = false
var player = null

const SPEED = 300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



func _physics_process(_delta: float) -> void:
	process_movement()
	move_and_slide()
# movement 


func process_movement() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left","right","up","down")
	
	play_ani(direction)
	
	velocity = direction * SPEED
	
func play_ani(dir: Vector2) -> void:
	if dir.x > 0:
		animated_sprite_2d.play("walk_right")
	elif dir.x < 0:
		animated_sprite_2d.play("walk_left")
	elif dir.y < 0:
		animated_sprite_2d.play("walk_back")
	elif dir.y > 0:
		animated_sprite_2d.play("walk_front")


func _on_Area_2d_body_entered(body: Node2D) -> void:
	if body.name == "cop":
		player_in_range = true
		player = body
		print("Player entered range")


func _on_Area_2d_body_exited(body: Node2D) -> void:
	if body.name == "cop":
		player_in_range = false
		player = null
		print("Player left range")


func _on_mall_body_entered(body: Node2D) -> void:
	print("ENTERED:", body.name)

	# If the player enters the mall trigger
	if body == self:
		print("GOING TO MALL 🚪")
		get_tree().change_scene_to_file("res://scenes/levels/mall_map.tscn")
