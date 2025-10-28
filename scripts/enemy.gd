extends CharacterBody2D


@export var speed = 100
@export var maxHealth : float = 100.0
@export var attackDamage : float = 5.0

var health : float = maxHealth

var currentDamageBuildUp = null

var targetingPlayer = null
@onready var damage_area: Area2D = $damage_area


func _ready() -> void:
	$attack_time.connect("timeout", attack)


func attack():
	if damage_area.has_overlapping_bodies():
		var player = damage_area.get_overlapping_bodies()[0]
		player.Damage(attackDamage)


func _physics_process(delta: float) -> void:
	var noise_text : NoiseTexture2D = $body.texture
	noise_text.noise.offset.x += 0.5*delta
	
	
	targetingPlayer = get_tree().get_first_node_in_group("player")
	var dir = global_position.direction_to(targetingPlayer.global_position)
	velocity = velocity.lerp(dir*speed,0.1)
	
	global_rotation = lerp_angle(global_rotation, global_position.angle_to_point(targetingPlayer.global_position), 0.5)
	
	move_and_slide()
	

func Damage(val):
	health -= val
	if health <= 0:
		queue_free()
	else:
		if currentDamageBuildUp == null:
			currentDamageBuildUp = load("res://nodes/systems/damageBuildup.tscn").instantiate()
			add_child(currentDamageBuildUp)
			currentDamageBuildUp.addDamage(val)
		else:
			currentDamageBuildUp.addDamage(val)
