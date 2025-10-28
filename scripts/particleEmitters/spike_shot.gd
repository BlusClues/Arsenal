extends Marker2D

@onready var sphere: MeshInstance2D = $sphere

# Cubic interpolate a position.

var physics_func = []

func shoot(shoot_pos):
	var insts = []
	var prevPos = global_position
	var maxBends = 30.0
	var mousePos = shoot_pos
	var halfway = prevPos.lerp(mousePos, 0.5)
	var halfhalfway = prevPos.lerp(mousePos, 0.25)
	var rng_control1 = halfway + Vector2(randf_range(-50,50),randf_range(-50,50))*5
	var rng_control2 = halfhalfway + Vector2(randf_range(-50,50),randf_range(-50,50))*5
	var speedx = 10.0
	var frame = 0
	# Should be 30 bends per second.
	for i in range(maxBends*1.1):
		if maxBends > 30 && frame >= (1) or maxBends <= 30 && frame >= 1 : # 5 / 30 = 0.16, so if frame is over 0.16, but frame will always be over.
			# 0.0333 which we can not do, since it is unstable.
			await get_tree().create_timer(1.0/(clampi(maxBends,1,30))).timeout
			frame = 0
		frame += 1 * (30/maxBends)
		
		var sphereC = sphere.duplicate()
		sphereC.visible = true
		
		sphereC.global_position = prevPos
		
		sphereC.global_position = prevPos.bezier_interpolate(rng_control1, rng_control2, mousePos, i/maxBends)
		var future_position = prevPos.bezier_interpolate(rng_control1, rng_control2, mousePos, (i+1)/maxBends)
		sphereC.look_at(future_position)
		var dist = sphereC.global_position.distance_to(future_position)
		sphereC.scale = Vector2(dist, 14)
		get_tree().current_scene.add_child(sphereC)
		insts.append(sphereC)
	
	
	for invis in range(100/speedx):
		for i_2 in range(insts.size()):
			insts[i_2].self_modulate = Color8(255,255,255,int(255.0*((100.0-invis*speedx)/100.0)))
			insts[i_2].scale = Vector2(insts[i_2].scale.x, insts[i_2].scale.y/1.05)
			
		await get_tree().create_timer(0.05).timeout

	for i_2 in range(insts.size()):
		insts[i_2].queue_free()
	queue_free()
	# Now they all shall..
