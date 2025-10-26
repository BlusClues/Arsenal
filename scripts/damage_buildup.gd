extends Node2D

var damageTotal = 0

func _physics_process(_delta: float) -> void:
	$dmg.scale = $dmg.scale.lerp(Vector2.ONE, 0.15)
	$dmg.position = $dmg.position.lerp(Vector2.ZERO, 0.15)


func addDamage(val):
	#floorf(val*1000) / 1000.0
	damageTotal += val
	# If damage is 100, that is lotsa damage enough to create big shake
	$dmg.position += Vector2(randf_range(-val,val),randf_range(-val,val))
	$dmg.scale += Vector2(val/10.0, val/10.0)
	$dmg.text = str(snappedf(damageTotal,0.01))
	if snappedf(damageTotal,0.01) == int(damageTotal):
		$dmg.text = str(int(damageTotal))
	$exit_time.stop()
	$exit_time.start() 
	# Reset time


func _on_exit_time_timeout() -> void:
	queue_free()
