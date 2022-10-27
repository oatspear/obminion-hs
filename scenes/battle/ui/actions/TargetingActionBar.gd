extends VBoxContainer

################################################################################
# Signals
################################################################################

signal selected_targets()
signal cancel_action()

################################################################################
# Variables
################################################################################

var valid_targets: Array = []

onready var label: RichTextLabel = $Label

################################################################################
# Interface
################################################################################


func clear_targets():
    valid_targets = []


func select_from_targets(minions):
    for minion in minions:
        pass


################################################################################
# Event Handlers
################################################################################


func _on_cancel_pressed():
    emit_signal("cancel_action")


func _on_attack_pressed():
    pass #emit_signal("attack_target")
