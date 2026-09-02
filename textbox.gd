extends CanvasLayer

@onready var label = $MarginContainer/Panel/Label

func _ready():
	visible = false   # 👈 HIDE at start

func start_chat(npc_name, message):
	label.text = npc_name + ": " + message
	visible = true

func hide_message():
	visible = false
