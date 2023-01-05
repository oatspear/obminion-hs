extends PanelContainer

################################################################################
# Signals
################################################################################

signal selected_commander()

################################################################################
# Variables
################################################################################

onready var commander = $Elements/Middle/Commander

################################################################################
# Interface
################################################################################


func enable_commander_selection(retain_selection: bool = true):
    commander.set_retain_selection(retain_selection)
    commander.set_selectable(true)


func disable_commander_selection():
    commander.set_selectable(false)


################################################################################
# Event Handlers - Primary
################################################################################


func _on_commander_selected():
    emit_signal("selected_commander")
