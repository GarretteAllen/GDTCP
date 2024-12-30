extends Node

var Messages : Array = [
	"REGISTER",
	"LOGIN",
	"WELCOME",
	"DISCONNECT",
	"MOVEMENT",
	"POSITION",
	"COMBAT",
	"ERROR",
	"STATREQUEST",
	"STATRESPONSE"
]

func send_movement_update(player_id: String, target_position: Vector2):
	if Server.connected == false:
		print("Error: Server not connected")
		return
	var message = (Messages[4] + " " + player_id + " " + str(target_position.x) + " " + str(target_position.y) + "\n").to_utf8_buffer()
	Server.server.put_data(message)
	print("Movement update sent for player: ", player_id, " to: ", str(target_position.x) + " " + str(target_position.y))

func send_stat_request(stat: String, player_id: String):
	if Server.connected == false:
		print("Error: Server not connected")
		return
	var message = (Messages[8] + " " + stat + " " + player_id + "\n").to_utf8_buffer()
	Server.server.put_data(message)
	print("Stat check sent for player: ", player_id)
