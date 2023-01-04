extends VBoxContainer

################################################################################
# Signals
################################################################################

signal end_turn()
signal forfeit()
signal cancel_action()

################################################################################
# Variables
################################################################################

onready var info_card = $InfoCard
onready var button_end_turn = $Actions/EndTurn
onready var button_forfet = $Actions/Forfeit

################################################################################
# Interface
################################################################################


func set_commander_data(commander_data: Dictionary):
    info_card.set_display_data(commander_data)


#func set_attack_enabled(button_enabled: bool):
#    if button_enabled:
#        button_attack.disabled = false
#        button_attack.show()
#    else:
#        button_attack.disabled = true
#        button_attack.hide()


################################################################################
# Event Handlers
################################################################################


func _on_cancel_pressed():
    emit_signal("cancel_action")


func _on_end_turn_pressed():
    emit_signal("end_turn")


func _on_forfeit_pressed():
    emit_signal("forfeit")

