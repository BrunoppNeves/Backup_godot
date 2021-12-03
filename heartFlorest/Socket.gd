extends Node

var client
var wrapped_client
var connected = false

var text = ""

signal interagir()
signal pular()
signal atacar()
signal potenciometro(valor)
signal joystick(valor)

func _ready():
	client = StreamPeerTCP.new()
	client.set_no_delay(true)
	connect_to_server();


func _exit_tree():
	disconnect_from_server()


func connect_to_server():
	var ip = "192.168.0.5"
	var port = 80
	print("Connecting to server: %s : %s" % [ip, str(port)])
	var connect = client.connect_to_host(ip, port)
	if client.is_connected_to_host():
		connected = true
		print("Connected!")


func disconnect_from_server():
	connected = false
	client.disconnect_from_host()


func _process(delta):
	if not connected:
		pass
	if connected and not client.is_connected_to_host():
		connected = false
	if client.is_connected_to_host():
		poll_server()


func poll_server():
	while client.get_available_bytes() > 0:
		var msg = client.get_utf8_string(client.get_available_bytes())
		if msg == null:
			continue;

		if msg.length() > 0:
			for c in msg:
				if c == "\n":
					on_text_received(text)
					text = ""
				else:
					text+=c


func on_text_received(text):
	var command_array = text.split(" ")

	if str(command_array[0]) == "yellow":
		emit_signal("atacar")
	elif str(command_array[0]) == "blue":
		emit_signal("interagir")
	elif str(command_array[0]) == "red":
		emit_signal("pular")
	elif command_array[0] == "lado:":
		emit_signal("joystick", int(command_array[1]))
	elif command_array[0].is_valid_float():
		emit_signal("potenciometro", float(command_array[0]))
	


func write_text(text):
	if connected and client.is_connected_to_host():
		print("Sending: %s" % text)
		client.put_data(text.to_ascii())
