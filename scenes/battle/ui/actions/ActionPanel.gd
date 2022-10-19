extends PanelContainer

################################################################################
# Signals
################################################################################

signal deploy_minion(minion)
signal use_support(support)
signal cancel_action()

################################################################################
# Event Handlers
################################################################################


func _on_army_action_bar_deploy_minion(minion):
    emit_signal("deploy_minion", minion)


func _on_army_action_bar_cancel_action():
    emit_signal("cancel_action")


func _on_support_action_bar_use_support(support):
    emit_signal("use_support", support)


func _on_support_action_bar_cancel_action():
    emit_signal("cancel_action")
