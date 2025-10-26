extends CharacterBody2D

@export var SPEED : float = 200

func _physics_process(_delta: float) -> void:
	var wish_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_forward", "move_backward"))
	velocity = velocity.lerp(wish_dir * SPEED, 0.25)
	
	look_at(get_global_mouse_position())
	
	move_and_slide()
	
	$Camera2D.position = $Camera2D.position.lerp(Vector2(0,0), 0.1)


func camShake(power, times, inBetween):
	for i in range(times):
		$Camera2D.position = $Camera2D.position + Vector2(randf_range(-power,power), randf_range(-power,power))
		await get_tree().create_timer(inBetween).timeout
