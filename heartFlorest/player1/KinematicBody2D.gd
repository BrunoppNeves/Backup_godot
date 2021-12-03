extends KinematicBody2D

var jump = -500;
var direction = Vector2.ZERO;
var gravity = 15;
const UP = Vector2(0, -1);
onready var g_rc= $grupo_rc;
var force_x = 0;
export var speed = 300;
export var knc_force = -150;
export var quickly_move = 250;
var isIdle = false;
var isJump = false;

func _ready():
	GameManager.set_player(get_node("."))

func _physics_process(delta):
	check_death()
	check_ground();
	falling();
	jump_player();
	move_player();
	move_and_slide(direction,UP);
	play_animations();

func falling():
	if (check_ground() == false):
		direction.y += gravity;
		move_and_slide(direction);

func move_player():
	force_x = GameManager.Inputs["joystick"]
	direction.x = force_x * speed
	$AnimatedSprite.flip_h = bool(direction.x < 0)

func jump_player():
	var is_on_ground = check_ground()
	
	if GameManager.Inputs["pular"] and is_on_ground:
		direction.y = jump
		$Jump.play()

func play_animations():
	if (check_ground() == false && isJump == true):
			$AnimatedSprite.play("jump");
			isJump = false;
		
	if(check_ground() == true):
		if(force_x != 0):
			$AnimatedSprite.play("run");
		else:
			if(isIdle == false):
				$AnimatedSprite.play("idle");
	
	if(GameManager.Inputs["atacar"]):
		isIdle = true;
		$AnimatedSprite.play("atk_bow");
		yield(get_tree().create_timer(1.6),"timeout");
		isIdle = false;

func check_death():
	if position.y >= 800:
		GameManager.player_death()

func check_ground():
	for check in g_rc.get_children():
		if check.is_colliding():
			return true;
		if !check.is_colliding():
			return false;

