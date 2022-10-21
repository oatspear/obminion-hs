extends PanelContainer

################################################################################
# Signals
################################################################################

signal deploy_minion(minion)
signal use_support(support)
signal cancel_action()

################################################################################
# Variables
################################################################################

onready var army_action_bar = $ArmyActionBar
onready var support_action_bar = $SupportActionBar

################################################################################
# Interface
################################################################################


func show_army_bar():
    support_action_bar.hide()
    army_action_bar.reset_ui()
    army_action_bar.show()


func show_support_bar():
    army_action_bar.hide()
    support_action_bar.reset_ui()
    support_action_bar.show()


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
