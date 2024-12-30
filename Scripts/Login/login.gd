extends Control

@onready var username = $TextureRect/Username
@onready var password = $TextureRect/Password
@onready var loginButton = $TextureRect/Button


func _ready():
	pass


func _process(delta):
	pass


func _on_button_pressed():
	if username.text != "" && Server.server.get_status() == 2: #and password.text != "":
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
		Server.username = username.text
	if Server.server.get_status() != 2:
		print("server not connected")
