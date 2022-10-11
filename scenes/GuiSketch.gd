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

################################################################################
# Event Handlers
################################################################################


func _on_ActionPanel_spawn_minion(index):
    minion_row_player.enable_slot_selectors()


func _on_ActionPanel_use_support(index):
    pass # Replace with function body.


func _on_ActionPanel_end_turn():
    dialog_confirm.window_title = STR_POPUP_TITLE_END_TURN
    dialog_confirm.dialog_text = STR_POPUP_TEXT_END_TURN
    dialog_confirm.popup()


func _on_ActionPanel_forfeit_game():
    dialog_confirm.window_title = STR_POPUP_TITLE_FORFEIT
    dialog_confirm.dialog_text = STR_POPUP_TEXT_FORFEIT
    dialog_confirm.popup()


func _on_MinionRow_player_selected_left():
    minion_row_player.disable_slot_selectors()
    action_panel.reset_all_inputs()


func _on_MinionRow_player_selected_right():
    minion_row_player.disable_slot_selectors()
    action_panel.reset_all_inputs()
