extends Camera2D

var shake_strength: int = 0
var shake_remaining_time: float = 0
var is_shaking: bool = false

export(Vector2) var base_position

func _ready() -> void:
	randomize()
	GameManager.camera = get_node(".")
	
	
func shake(new_shake_strength: int, shake_lifetime: float) -> void:
	if shake_strength > new_shake_strength:
		return
		
	shake_strength = new_shake_strength
	shake_remaining_time = shake_lifetime
	
	if is_shaking:
		return
		
	is_shaking = true
	
	while shake_remaining_time > 0:
		var pos: Vector2 = Vector2.ZERO
		pos.x = rand_range(-shake_strength, shake_strength) 
		set_position(base_position + pos)
		
		shake_remaining_time -= get_process_delta_time() #1/60 -> 0.016667
		yield(get_tree(), "idle_frame")
		
	shake_strength = 0
	is_shaking = false
	set_position(base_position)
