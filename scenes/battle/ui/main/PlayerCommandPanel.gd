extends PanelContainer

################################################################################
# Signals
################################################################################

signal check_army_left()
signal check_army_right()
signal check_support()
signal check_graveyard()
signal check_commander()

################################################################################
# Event Handlers
################################################################################


func _on_left_army_pressed():
    emit_signal("check_army_left")


func _on_support_pressed():
    emit_signal("check_support")


func _on_commander_selected():
    emit_signal("check_commander")


func _on_right_army_pressed():
    emit_signal("check_army_right")


func _on_graveyard_pressed():
    emit_signal("check_graveyard")
