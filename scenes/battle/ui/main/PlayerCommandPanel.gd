extends PanelContainer

################################################################################
# Signals
################################################################################

signal show_card_info(data)
signal hide_card_info()
signal deploy_minion(minion, right_side)

################################################################################
# Variables
################################################################################

onready var main_panel = $MainCommandCard
onready var army_action_bar = $ArmyActionBar
onready var support_action_bar = $SupportActionBar
onready var minion_action_bar = $MinionActionBar

var _deploy_right_side: bool = true

################################################################################
# Interface
################################################################################


func show_main_command_card():
    for action_bar in get_children():
        action_bar.hide()
    main_panel.show()


func show_army_action_bar():
    for action_bar in get_children():
        action_bar.hide()
    army_action_bar.reset_ui()
    army_action_bar.show()


func show_support_action_bar():
    for action_bar in get_children():
        action_bar.hide()
    support_action_bar.reset_ui()
    support_action_bar.show()


func show_minion_action_bar():
    for action_bar in get_children():
        action_bar.hide()
    # minion_action_bar.reset_ui()
    minion_action_bar.show()


################################################################################
# Event Handlers - Primary
################################################################################


func _on_check_army_left():
    _deploy_right_side = false
    show_army_action_bar()


func _on_check_army_right():
    _deploy_right_side = true
    show_army_action_bar()


func _on_check_commander():
    pass # Replace with function body.


func _on_check_graveyard():
    pass # Replace with function body.


func _on_check_support():
    show_support_action_bar()


################################################################################
# Event Handlers - Secondary
################################################################################


func _on_cancel_action():
    show_main_command_card()
    emit_signal("hide_card_info")


func _on_display_info(data: Dictionary):
    emit_signal("show_card_info", data)


func _on_hide_info():
    emit_signal("hide_card_info")


func _on_deploy_minion(minion):
    emit_signal("deploy_minion", minion, _deploy_right_side)
