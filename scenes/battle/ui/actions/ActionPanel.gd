extends PanelContainer


################################################################################
# Event Handlers
################################################################################

func _on_army_show_info(minion_data: Dictionary):
    $Elements/MinionInfoPanel.set_minion_data(minion_data)
