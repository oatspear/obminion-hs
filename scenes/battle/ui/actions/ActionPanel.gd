extends PanelContainer

################################################################################
# Constants
################################################################################

const NO_DATA: Dictionary = {}

################################################################################
# Variables
################################################################################

onready var panel_info = $Elements/MinionInfoToggle

################################################################################
# Event Handlers
################################################################################


func _on_army_minion_selected(minion_data: Dictionary):
    panel_info.set_display_data(minion_data)


func _on_army_minion_deselected():
    panel_info.set_display_data(NO_DATA)
