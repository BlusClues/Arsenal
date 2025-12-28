extends CharacterBody2D

@export var speed = 100
@export var damageDealt = 5
var targetingPlayer = null
var damageCooldown: float = 0.0

func _ready() -> void:
	#Find the player once when the enemy spawns
	targetingPlayer = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	#Decrease the cooldown timer every frame
	if damageCooldown > 0:
		damageCooldown -= delta
	
	if targetingPlayer:
		#Move towards player
		var dir = global_position.direction_to(targetingPlayer.global_position)
		velocity = velocity.lerp(dir * speed, 0.1)
		
		#Rotate towards player
		global_rotation = lerp_angle(global_rotation, global_position.angle_to_point(targetingPlayer.global_position), 0.5)
		
		move_and_slide()
		
		#Check everything we bumped into during move_and_slide()
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			#If we hit the player and our cooldown is ready
			if collider.is_in_group("player") and damageCooldown <= 0:
				if collider.has_method("take_damage"):
					collider.take_damage(damageDealt)
					damageCooldown = 1.0 
