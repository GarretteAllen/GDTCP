extends Node

var host : String = "127.0.0.1"
var port : int = 31333
var server : StreamPeerTCP
var connected : bool = false
var sent : bool = false
var username : String = ""

func _ready():
	server = StreamPeerTCP.new()
	server.connect_to_host(host, port)
	print("Attempting to connect...")
	while true:
		var available_bytes = server.get_available_bytes()
		if available_bytes > 0:
			var chunk = server.get_data(available_bytes)
			Handler.handle_incoming_data(chunk[1].get_string_from_utf8())
		await get_tree().create_timer(0.1).timeout

func _process(delta):
	server.poll()
	
	# Check connection status
	if server.get_status() == 2 and not connected:
		connected = true
		print("Connected to server!")

	if connected and username != "" and sent == false:
		_send_username()

func _send_username():
	var pba = (username + "\n").to_utf8_buffer()
	server.put_data(pba)
	sent = true
	print("Sent username:", username)
