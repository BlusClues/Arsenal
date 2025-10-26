extends Node2D

const PARTICLE_EMITTERS = preload("uid://c0bqf7tpveusg")


func m1():
	print("rahhh")
	var particle_C = PARTICLE_EMITTERS.instantiate()
	particle_C.position = global_position
	get_node("particleDump").add_child(particle_C)
	particle_C.shoot(get_global_mouse_position())
	
