extends PanelContainer

################################################################################
# Signals
################################################################################

signal spawn_minion(index)
signal use_support(index)
signal forfeit_game()
signal end_turn()

################################################################################
# Variables
################################################################################

onready var action_bar_army: Control = $Margin/VBox/ArmyActionBar
onready var action_bar_support: Control = $Margin/VBox/SupportBar
onready var action_bar_primary: Control = $Margin/VBox/PrimaryActionBar

################################################################################
# Interface
################################################################################


func reset_all_inputs():
    action_bar_primary.deselect_toggles()


func hide_secondary_action_bars():
    action_bar_army.hide()
    action_bar_support.hide()


################################################################################
# Event Handlers
################################################################################


func _ready():
    hide_secondary_action_bars()


func _on_PrimaryActionBar_show_army():
    action_bar_army.show()
    action_bar_army.reset_buttons()


func _on_PrimaryActionBar_hide_army():
    action_bar_army.hide()


func _on_PrimaryActionBar_show_support():
    action_bar_support.show()


func _on_PrimaryActionBar_hide_support():
    action_bar_support.hide()


func _on_PrimaryActionBar_end_turn_pressed():
    hide_secondary_action_bars()
    emit_signal("end_turn")


func _on_PrimaryActionBar_surrender_pressed():
    hide_secondary_action_bars()
    emit_signal("forfeit_game")


func _on_ArmyActionBar_selected_unit(i: int):
    emit_signal("spawn_minion", i)
