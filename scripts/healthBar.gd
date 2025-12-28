extends ProgressBar

#Function runs whenever the player gets hurt
func _on_player_health_changed(new_health: int) -> void:
	value = new_health
