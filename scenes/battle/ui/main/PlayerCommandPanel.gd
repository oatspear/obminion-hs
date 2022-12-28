extends PanelContainer

################################################################################
# Signals
################################################################################

signal show_card_info(data)
signal hide_card_info()
signal deselect_minions()
signal deploy_minion(army_index, right_side)
signal select_targets(mode)
signal confirm_end_turn()
signal confirm_forfeit()

################################################################################
# Variables
################################################################################

var enabled: bool = true

onready var commander = $MainCommandCard/Middle/Commander
onready var main_panel = $MainCommandCard
onready var army_action_bar = $ArmyActionBar
onready var support_action_bar = $SupportActionBar
onready var minion_action_bar = $MinionActionBar
onready var commander_action_bar = $CommanderActionBar

var _deploy_right_side: bool = true

################################################################################
# Interface
################################################################################


func reset_data():
    army_action_bar.reset_data()
    support_action_bar.reset_data()


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


func show_minion_action_bar(minion_data: Dictionary, can_act: bool):
    for action_bar in get_children():
        action_bar.hide()
    # minion_action_bar.reset_ui()
    minion_action_bar.set_minion_data(minion_data)
    if can_act:
        minion_action_bar.set_attack_enabled(true)
    else:
        minion_action_bar.set_attack_enabled(false)
    minion_action_bar.show()


func show_commander_action_bar(player_commander: bool):
    for action_bar in get_children():
        action_bar.hide()
    # commander_action_bar.set_minion_data(minion_data)
    #if player_commander:
    #    commander_action_bar.set_attack_enabled(true)
    #else:
    #    commander_action_bar.set_attack_enabled(false)
    commander_action_bar.show()


################################################################################
# Event Handlers - Primary
################################################################################


func _on_check_army_left():
    if enabled:
        _deploy_right_side = false
        show_army_action_bar()


func _on_check_army_right():
    if enabled:
        _deploy_right_side = true
        show_army_action_bar()


func _on_check_commander():
    if enabled:
        show_commander_action_bar(true)


func _on_check_graveyard():
    if enabled:
        pass # Replace with function body.


func _on_check_support():
    if enabled:
        show_support_action_bar()


################################################################################
# Event Handlers - Secondary
################################################################################


func _on_cancel_action():
    show_main_command_card()
    emit_signal("hide_card_info")
    emit_signal("deselect_minions")


func _on_display_info(data: Dictionary):
    emit_signal("show_card_info", data)


func _on_hide_info():
    emit_signal("hide_card_info")


func _on_deploy_minion(army_index: int):
    emit_signal("deploy_minion", army_index, _deploy_right_side)


func _on_attack_target():
    emit_signal("select_targets", Global.TargetMode.ATTACK_TARGET)


func _on_end_turn():
    emit_signal("confirm_end_turn")


func _on_forfeit():
    emit_signal("confirm_forfeit")
