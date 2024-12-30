extends Node

signal tree_hovered(tree_name: String)
signal tree_left()

func emit_tree_hovered(tree_name: String):
	emit_signal("tree_hovered", tree_name)
	
func emit_tree_left():
	emit_signal("tree_left")
