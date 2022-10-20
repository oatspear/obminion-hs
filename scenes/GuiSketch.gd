extends MarginContainer

################################################################################
# Constants
################################################################################

const STR_POPUP_TITLE_END_TURN = "End Turn"
const STR_POPUP_TEXT_END_TURN = "End your turn?"

const STR_POPUP_TITLE_FORFEIT = "Forfeit"
const STR_POPUP_TEXT_FORFEIT = "Forfeit the game?"

################################################################################
# Variables
################################################################################

onready var minion_row_player = $Layer1/BattleField/MinionField/VBoxContainer/Bottom
onready var action_panel = $Layer2/ActionPanel
onready var dialog_confirm: ConfirmationDialog = $Layer3/Confirm

var _num_minions = 0

################################################################################
# Event Handlers
################################################################################


func _on_ActionPanel_spawn_minion(_index):
    action_panel.reset_all_inputs()
    var ok = minion_row_player.append_minion()
    if not ok:
        print("The minion board is full.")


func _on_ActionPanel_use_support(_index):
    pass # Replace with function body.


func _on_ActionPanel_end_turn():
    dialog_confirm.window_title = STR_POPUP_TITLE_END_TURN
    dialog_confirm.dialog_text = STR_POPUP_TEXT_END_TURN
    dialog_confirm.popup()


func _on_ActionPanel_forfeit_game():
    dialog_confirm.window_title = STR_POPUP_TITLE_FORFEIT
    dialog_confirm.dialog_text = STR_POPUP_TEXT_FORFEIT
    dialog_confirm.popup()


func _on_cancel_action():
    action_panel.hide()


func _on_PlayerCommandPanel_check_army_left():
    action_panel.show_army_bar()
    action_panel.show()


func _on_PlayerCommandPanel_check_army_right():
    action_panel.show_army_bar()
    action_panel.show()


func _on_PlayerCommandPanel_check_support():
    action_panel.show_support_bar()
    action_panel.show()
