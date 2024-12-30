extends Node2D

class_name Trees
var treeName = "Tree"
signal mouseHovered

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hover_area_mouse_entered():
	SignalManager.emit_tree_hovered(treeName)


func _on_hover_area_mouse_exited():
	SignalManager.emit_tree_left()
