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

onready var action_panel = $BattleField/PlayerCommandPanel
onready var minion_row_player = $BattleField/Center/MinionField/Bottom
onready var dialog_confirm: ConfirmationDialog = $Popups/Confirm
onready var popup_card_info = $Popups/InfoCardPopup

var _selected_minion: WeakRef = weakref(null)

################################################################################
# Interface
################################################################################


func enter_main_phase():
    minion_row_player.enable_minion_selection(true)


################################################################################
# Event Handlers
################################################################################


func _ready():
    enter_main_phase()


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


func _on_show_card_info(data):
    popup_card_info.set_display_data(data)
    #popup_card_info.popup_centered()
    popup_card_info.show()


func _on_hide_card_info():
    if popup_card_info:
        popup_card_info.hide()


func _on_deploy_minion(minion_data: Dictionary, right_side: bool):
    _on_hide_card_info()
    action_panel.show_main_command_card()
    var ok = true
    if right_side:
        ok = minion_row_player.append_minion(minion_data)
    else:
        ok = minion_row_player.preprend_minion(minion_data)
    if not ok:
        print("The minion board is full.")


func _on_player_minion_selected(minion):
    # main phase
    var prev = _selected_minion.get_ref()
    _selected_minion = weakref(minion)
    if prev != null and prev != minion:
        prev.set_selected(false)
    action_panel.show_minion_action_bar(minion.minion_data)


func _on_player_minion_deselected(minion):
    # main phase
    var prev = _selected_minion.get_ref()
    if prev != null and prev == minion:
        _selected_minion = weakref(null)
        action_panel.show_main_command_card()
