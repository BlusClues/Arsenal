extends Node2D

@export var damagePerScream : float = 50.9/(30*5)
@export var damagePerHit : float = 25.0
@export var maximumHits = 3

var leftOrRight = 0
var hitSwing = false
var Screaming = false

var alreadyHit = []
var alreadyScreamed = []

@onready var scream_area: Area2D = $scream_area
@onready var eat_area: Area2D = $eat_area
@onready var player: CharacterBody2D = get_parent().get_parent()

func m1():
	if hitSwing or Screaming:
		return
	if leftOrRight == 0:
		leftOrRight = 1
		$anim.play("swing_from_right")
	elif leftOrRight == 1:
		leftOrRight = 0
		$anim.play("swing_from_left")
	
	hitSwing = true
	await $anim.animation_finished
	hitSwing = false
	alreadyHit = []


func e_key():
	if hitSwing or Screaming:
		return
	# Wait for 5 seconds while doing..
	# Attack 30 times over a big radius for each second
	# adding up to 50 total damage
	Screaming = true
	$scream_particles.emitting = true
	$anim.play("scream", 0.25)
	await get_tree().create_timer(0.5).timeout
	for i in range(30*5):
		alreadyScreamed = []
		var bodies = scream_area.get_overlapping_bodies()
		for i_2 in range(bodies.size()):
			if !alreadyScreamed.has(bodies[i_2].name) && bodies[i_2].is_in_group("enemies"):
				alreadyScreamed.append(bodies[i_2].name)
				bodies[i_2].Damage(damagePerScream)
		
		await get_tree().create_timer(1.0/30.0).timeout
		player.camShake(5, 1, 0.025)
	$anim.play("idle_swing",0.25)
	Screaming = false
	$scream_particles.emitting = false


func activated():
	visible = true


func deactivated():
	visible = false


func _physics_process(_delta: float) -> void:
	
	if hitSwing and alreadyHit.size() < maximumHits:
		var bodies = eat_area.get_overlapping_bodies()
		for i in range(bodies.size()):
			if !alreadyHit.has(bodies[i].name) && bodies[i].is_in_group("enemies"):
				alreadyHit.append(bodies[i].name)
				bodies[i].Damage(damagePerHit)
				if alreadyHit.size() >= maximumHits:
					break
