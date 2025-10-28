extends Node2D

var damageTotal = 0
var growTime = 0

var growing = false

@onready var dmg: Label = $global/dmg

# Grow time gets bigger more time the damage is still held..


func _ready() -> void:
	dmg.position = global_position


func _physics_process(_delta: float) -> void:
	if !growing:
		dmg.scale = dmg.scale.lerp(Vector2.ONE, 0.05)
		dmg.position = dmg.position.lerp(global_position, 0.15)
		dmg.self_modulate.a8 = lerp(dmg.self_modulate.a8, 255, 0.05)
	dmg.rotation = lerp(dmg.rotation, 0.0, 0.15)


func addDamage(val):
	#floorf(val*1000) / 1000.0
	damageTotal += val
	# If damage is 100, that is lotsa damage enough to create big shake
	dmg.position += Vector2(randf_range(-val,val),randf_range(-val,val))
	dmg.rotation += randf_range(-val/8.0, val/8.0)
	dmg.scale += Vector2(val/15.0, val/15.0)
	dmg.text = str(snappedf(damageTotal,0.01))
	dmg.self_modulate.a8 = dmg.self_modulate.a8 - (255/175.0) # 100 hits to make it go invis
	dmg.self_modulate.a8 = clampf(dmg.self_modulate.a8, 30, 255)
	if snappedf(damageTotal,0.01) == int(damageTotal):
		dmg.text = str(int(damageTotal))
	$exit_time.stop()
	$exit_time.start() 
	$grow_time.stop()
	$grow_time.start()
	growing = true
	# Reset time


func _on_exit_time_timeout() -> void:
	queue_free()


func _on_grow_time_timeout() -> void:
	growing = false
