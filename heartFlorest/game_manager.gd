extends Node

var rng = RandomNumberGenerator.new()
var previus_time = 0;
var Inputs = {
	"tipo": "teclado",
	"joystick": 0,
	"potenciometro": 0,
	"pular": false,
	"interagir": false,
	"atacar": false
};
var alpha
var player
var camera
var player_life
const meteoro = preload("res://assets/meteor/meteoro.tscn");
var meteoro_previus_time
export var frequency = 1000

func _ready():
	# SISTEMA DE INPUTS
	Socket.connect("potenciometro", self, "_on_potenciometro")
	Socket.connect("joystick"     , self, "_on_joystick"     )
	Socket.connect("atacar"       , self, "_on_atacar"       )
	Socket.connect("pular"        , self, "_on_pular"        )
	Socket.connect("interagir"    , self, "_on_interagir"    )

	game_start()
	
	
func game_start():
	#print("Reiniciando Jogo")
	player_life = 99
	alpha = 1
	meteoro_previus_time = 0


func set_player(node):
	player = node
	camera = player.get_node("Camera2D")


func player_took_damage(damage):
	player_life -= damage
	player.get_node("Damage").play()
	
func player_death():
	if is_instance_valid(player):
		print("Player Morreu")
		# Player morreu, recarrega a 1ª Fase
		get_tree().change_scene("res://game_over/CanvasLayer.tscn")
		game_start()


func _process(delta):
	if player_life <= 0:
		print("Player Morreu")
		# Player morreu, recarrega a 1ª Fase
		get_tree().change_scene("res://game_over/CanvasLayer.tscn")
		game_start()
		
	if OS.get_system_time_msecs() - meteoro_previus_time >= frequency:
		#print("Gerando meteoro...")
		var m = meteoro.instance()
		if is_instance_valid(m) and is_instance_valid(player):
			m.position.x = player.position.x
			m.position.y = player.position.y - 700
			get_parent().add_child(m)
			meteoro_previus_time = OS.get_system_time_msecs()
		
	# BRAIN - INPUT
	var value = Inputs["potenciometro"]
	if is_instance_valid(player): # Evita problema quando player morre
		var cores = player.modulate
		alpha = lerp(alpha, 1 - value, 0.1)
		player.modulate = Color(cores[0], cores[1], cores[2], alpha)
		if value > 0.5 and is_instance_valid(camera) and camera.has_method("shake"):
			camera.shake(value * 10, value * 0.5)
	
	# COMPATIBILIDADE COM INPUT DO TECLADO
	if Inputs["tipo"] == "teclado":
		var right_force = Input.get_action_strength("rig")
		var left_force  = Input.get_action_strength("lef" )
		Inputs["joystick"] = int(right_force - left_force)
		
		Inputs["pular"]  = Input.is_action_pressed("up")
		Inputs["atacar"] = Input.is_action_pressed("atk")
		
		if Inputs["potenciometro"] + 0.1 <= 1 and Input.is_action_just_pressed("value_up"):
			Inputs["potenciometro"] += 0.1
		elif Inputs["potenciometro"] - 0.1 >= 0 and Input.is_action_just_pressed("value_down"):
			Inputs["potenciometro"] -= 0.1
			
	if OS.get_system_time_msecs() - previus_time >= (2 * delta * 2000):
		clear_inputs();
		previus_time = OS.get_system_time_msecs();


func clear_inputs():
	# Zera Flags no final de cada frame
	Inputs["interagir"] = false
	Inputs["pular" ]    = false
	Inputs["atacar"]    = false


func _on_joystick(valor):
	var pot_value = valor
	var value

	if pot_value > 5:
		value = pot_value - 5
	elif pot_value < 5: # Lado negativo
		value = -5 + pot_value
	else:
		value = 0
		
	Inputs["joystick"] = value / 5
	Inputs["tipo"] = "esp"


func _on_potenciometro(valor):
	Inputs["potenciometro"] = float(valor)
	Inputs["tipo"] = "esp"

func _on_pular():
	Inputs["pular"] = true
	Inputs["tipo"] = "esp"

func _on_interagir():
	Inputs["interagir"] = true
	Inputs["tipo"] = "esp"

func _on_atacar():
	Inputs["atacar"] = true
	Inputs["tipo"] = "esp"

func get_brain_input():
	return float(Inputs["potenciometro"])
