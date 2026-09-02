extends CanvasLayer

func _ready():
	hide()  # hidden at start

func show_message(npc_name: String, message: String):
	$PanelContainer/VBoxContainer/NPCName.text = npc_name
	$PanelContainer/VBoxContainer/DialogueText.text = message
	show()

func hide_message():
	hide()
