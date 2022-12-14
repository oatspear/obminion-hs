extends VBoxContainer

################################################################################
# Signals
################################################################################

signal attack_target()
signal cancel_action()

################################################################################
# Variables
################################################################################

onready var info_card = $InfoCard
onready var button_attack = $Actions/Attack

################################################################################
# Interface
################################################################################


func set_minion_data(minion_data: Dictionary):
    info_card.set_display_data(minion_data)


func set_attack_enabled(button_enabled: bool):
    if button_enabled:
        button_attack.disabled = false
        button_attack.show()
    else:
        button_attack.disabled = true
        button_attack.hide()


################################################################################
# Event Handlers
################################################################################


func _on_cancel_pressed():
    emit_signal("cancel_action")


func _on_attack_pressed():
    emit_signal("attack_target")
