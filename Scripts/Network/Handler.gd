extends Node

var message_buffer = ""
var player_character: Node2D = null
var scene_ready = false
signal stat_changed(stat, amount)

func handle_incoming_data(chunk: String):
	message_buffer += chunk
	while message_buffer.find("\n") != -1:
		var end_idx = message_buffer.find("\n")
		var message = message_buffer.substr(0, end_idx)
		message_buffer = message_buffer.substr(end_idx + 1)
		if message == "":
			continue
		if !Global.main_ready:
			print("FUCK!")
			
		process_message(message)
		
func process_message(message: String):
	print("Processing message ", message)
	var split_index = message.find(" ")
	if split_index == 1:
		print("Malformed message from server:", message)
		return
		
	var msg_type = message.substr(0, split_index)
	var payload = message.substr(split_index + 1)
	
	match msg_type:
		"WELCOME":
			handle_welcome_message(payload)
			print("Welcome message recieved:", message )
			
		"POSITION":
			handle_position_message(payload)
			print("Position message received: ", message)
		"COMBAT":
			handle_combat_message(payload)
			print("Combat message received: ", message)
			
		"DISCONNECT":
			handle_disconnect_message(payload)
			print("Disconnect message recived: ", message)
			
		"STATRESPONSE":
			handle_stat_response_message(payload)
			print("Stat response message recieved: ", message)
		_:
			print("Unknown message type: ", message)


func handle_welcome_message(payload: String):
	var parts = payload.strip_edges().split(" ")
	if parts.size() != 2:
		print("invalid welcome payload", payload)
		return
	var message = parts[0]
	var username = parts[1]
	MpManager.local_player_id = username
	print("welcome message received, local player is set to: ", MpManager.local_player_id)

func handle_position_message(payload: String):
	var parts = payload.strip_edges().split(" ")
	if parts.size() != 3:
		print("invalid position payload:", payload)
		return
		
	var username = parts[0]
	var x = parts[1].to_float()
	var y = parts[2].to_float()
	var position = Vector2(x, y)
	print("Position received: ", username, " ", x,  " ", y)
	
	if MpManager.players.has(username):
		if username == MpManager.local_player_id:
			print("skipping update for local player:", username)
			return
		else:
			MpManager.update_player_target(username, position)
	else:
		MpManager.spawn_player(username, position)
	
func handle_disconnect_message(payload: String):
	var parts = payload.strip_edges().split(" ")
	if parts.size() != 1:
		print("Invalid disconnect message")
		return
	var username = parts[0]
	print(username, " is disconnecting")
	MpManager.despawn_player(username)
	# Save player data?
		
func handle_stat_response_message(payload: String):
	var parts = payload.strip_edges().split(" ")
	if parts.size() != 2:
		print("Invalid stat response")
		return
	var stat = parts[0]
	var level = parts[1]
	emit_signal("stat_changed", stat, level)
	
func handle_combat_message(payload: String):
	pass
