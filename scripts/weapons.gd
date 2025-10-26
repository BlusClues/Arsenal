extends Node2D


# If your weapon has an m1 it will be called, m2 also, when mouse is down or right mouse is down.
# If it has a m1_up or m2_up it will be called when left mouse is up or right mouse is up
# Just call it func m1(): and the script will check for you.

# Don't need to actually have a m2() in your script if it is not required for your weapon, it won't
# error trying to call it.

# Deactivated and Activated are optional too, they only happen if you want to do something when the
# weapon is switched to, or switched off, such as cleaning up variables.

var currentWeapon : Node = null

# If any weapons want to get this node, and get the player of this node, ig this could be a reference.
@onready var Player = get_parent()

func _ready():
	# First weapon will be activated.
	if get_child_count() > 0:
		currentWeapon = get_child(0)
		equipCurrentWeapon()



# may change this behaviour perhaps...
func childAdded(child):
	if currentWeapon == null:
		currentWeapon = child
		equipCurrentWeapon()


# may be pretty wasteful to check for methods do this each time, but goofing off here.
func _input(event):
	if event.is_action_pressed("m1"):
		if currentWeapon.has_method("m1"):
			currentWeapon.call_deferred("m1")
	if event.is_action_pressed("m2"):
		if currentWeapon.has_method("m2"):
			currentWeapon.call_deferred("m2")
	
	if event.is_action_released("m1"):
		if currentWeapon.has_method("m1_up"):
			currentWeapon.call_deferred("m1_up")
	if event.is_action_released("m2"):
		if currentWeapon.has_method("m1_up"):
			currentWeapon.call_deferred("m1_up")
	
	if event.is_action_pressed("e"):
		if currentWeapon.has_method("e_key"):
			currentWeapon.call_deferred("e_key")
	if event.is_action_released("e"):
		if currentWeapon.has_method("e_key_up"):
			currentWeapon.call_deferred("e_key_up")

func equipCurrentWeapon():
	if currentWeapon.has_method("activated"):
		currentWeapon.call_deferred("activated")


func unequipCurrentWeapon():
	if currentWeapon.has_method("deactivated"):
		currentWeapon.call_deferred("deactivated")
