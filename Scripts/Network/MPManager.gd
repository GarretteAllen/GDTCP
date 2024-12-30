extends Node

var players: Dictionary = {}  
var player_scene = preload("res://Scenes/Player/Player.tscn") 
var local_player_id: String = ""  

func spawn_player(player_id: String, saved_position: Vector2):
	if players.has(player_id):
		print("Player with ID", player_id, "already exists.")
		return

	var player_instance = player_scene.instantiate() as Player
	player_instance.spawn(saved_position)
	player_instance.name = player_id
	#if player_id == local_player_id:
		#player_instance.name = local_player_id

	get_tree().get_current_scene().get_node("Players").add_child(player_instance)
	players[player_id] = player_instance
	print(players)
	print("Player with ID:", player_id, "spawned at:", saved_position)

func despawn_player(username):
	if players.has(username):
		print("Removing: ", username, " from player dictionary")
		players.erase(username)
		var player = get_tree().get_current_scene().get_node("Players/%s" % username)
		get_tree().get_current_scene().get_node("Players").remove_child(player)
	

func update_player_target(player_id: String, new_target: Vector2):
	if players.has(player_id):
		var player = players[player_id]
		if player_id == local_player_id:
			return
		player.update_target(new_target)
		print("Updated target for player:", player_id, "to:", new_target)

func get_player(player_id: String) -> Player:
	if players.has(player_id):
		return players[player_id]
	return null
	
func update_player_stats(player_id: String, stat: String):
	if players.has(player_id):
		pass
