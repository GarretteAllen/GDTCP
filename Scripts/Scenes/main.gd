extends Node2D

signal scene_ready
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.main_ready = true
