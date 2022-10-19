extends PanelContainer

################################################################################
# Constants
################################################################################

const NO_DATA: Dictionary = {}

################################################################################
# Variables
################################################################################

onready var panel_info = $Elements/MinionInfoPanel

################################################################################
# Event Handlers
################################################################################


func _on_army_minion_selected(minion_data: Dictionary):
    panel_info.set_minion_data(minion_data)


func _on_army_minion_deselected():
    panel_info.set_minion_data(NO_DATA)
