extends Control

@export var default_text := "Walk here"
@onready var command_label = $Command
@onready var name_label = $Name
var hovering: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Handler.connect("stat_changed", _on_stat_changed)
	Messenger.send_stat_request("HITPOINTS", MpManager.local_player_id)
	name_label.text = MpManager.local_player_id
	SignalManager.connect("tree_hovered", _on_tree_hovered)
	SignalManager.connect("tree_left", _on_tree_left)
	
func _process(delta):
	if !hovering:
		command_label.text = "%s %.2f %.2f" % [default_text, get_global_mouse_position().x, get_global_mouse_position().y]


func _on_tree_hovered(tree_name: String):
	hovering = true
	command_label.text = "Chop " + tree_name
	
func _on_tree_left():
	hovering = false
	
func _on_stat_changed(stat, amount):
	var label_path = "Stats/%s/%sLabel" % [stat, stat]
	var label = get_node(label_path)
	label.text = amount
