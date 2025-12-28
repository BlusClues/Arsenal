extends CharacterBody2D

@export var SPEED : int = 200
@export var maxHealth : int = 100

var health = maxHealth

signal healthChanged(newValue)

#Function for the player movement (WASD)
func _physics_process(_delta: float) -> void:
	var wish_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_forward", "move_backward"))
	velocity = velocity.lerp(wish_dir * SPEED, 0.25)
	
	#camera follows the player by getting their current position
	look_at(get_global_mouse_position())
	
	move_and_slide()
	
	$Camera2D.position = $Camera2D.position.lerp(Vector2(0,0), 0.1)


#function for when the player takes damage
#specifically when an enemy runs into a player
func take_damage(amount: int) -> void:
	health -= amount
	print("health = ", health)
	
	healthChanged.emit(health)
	
	if health <= 0:
		#simple restart (change later once more is added)
		get_tree().reload_current_scene()
