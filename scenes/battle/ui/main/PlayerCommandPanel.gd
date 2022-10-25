extends PanelContainer

################################################################################
# Signals
################################################################################

signal show_card_info(data)
signal hide_card_info()

################################################################################
# Variables
################################################################################

onready var main_panel = $MainCommandCard
onready var army_action_bar = $ArmyActionBar
onready var support_action_bar = $SupportActionBar

################################################################################
# Interface
################################################################################


func show_main_command_card():
    support_action_bar.hide()
    army_action_bar.hide()
    main_panel.show()


func show_army_action_bar():
    main_panel.hide()
    support_action_bar.hide()
    army_action_bar.reset_ui()
    army_action_bar.show()


func show_support_action_bar():
    main_panel.hide()
    army_action_bar.hide()
    support_action_bar.reset_ui()
    support_action_bar.show()


################################################################################
# Event Handlers
################################################################################


func _on_check_army_left():
    show_army_action_bar()


func _on_check_army_right():
    show_army_action_bar()


func _on_check_commander():
    pass # Replace with function body.


func _on_check_graveyard():
    pass # Replace with function body.


func _on_check_support():
    show_support_action_bar()


func _on_cancel_action():
    show_main_command_card()
    emit_signal("hide_card_info")


func _on_display_info(data: Dictionary):
    emit_signal("show_card_info", data)


func _on_hide_info():
    emit_signal("hide_card_info")
